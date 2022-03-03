require 'test_puppet_helper'

module ForemanPuppet
  class HostsControllerTest < ActionController::TestCase
    tests ::HostsController

    setup do
      @routes = ForemanPuppet::Engine.routes
      as_admin do
        host1
        host2
      end
    end

    let(:org) { users(:one).organizations.first }
    let(:loc) { users(:one).locations.first }
    let(:environment1) { FactoryBot.create(:environment, organizations: [org], locations: [loc]) }
    let(:environment2) { FactoryBot.create(:environment, organizations: [org], locations: [loc]) }
    let(:hostgroup) { FactoryBot.create(:hostgroup, :with_puppet_enc, environment: environment2, organizations: [org], locations: [loc]) }
    let(:host_defaults) { { hostgroup: hostgroup, environment: environment1, organization: org, location: loc } }
    let(:host1) { FactoryBot.create(:host, :with_puppet_enc, :with_puppetclass, host_defaults) }
    let(:host2) { FactoryBot.create(:host, :with_puppet_enc, :with_puppetclass, host_defaults) }

    test 'user with edit host rights with update environments should change environments' do
      @request.env['HTTP_REFERER'] = '/hosts'
      setup_user 'edit', 'hosts'

      post :update_multiple_environment, params: { host_ids: [host1.id, host2.id],
                                                   environment: { id: environment2.id } },
                                         session: set_session_user(:one)
      assert_equal environment2.id, host1.reload.puppet.environment_id
      assert_equal environment2.id, host2.reload.puppet.environment_id
      assert_equal 'Updated hosts: changed environment', flash[:success]
    end

    test 'should inherit the hostgroup environment if *inherit from hostgroup* selected' do
      @request.env['HTTP_REFERER'] = '/hosts'
      setup_user 'edit', 'hosts'

      params = { host_ids: [host1.id, host2.id], environment: { id: 'inherit' } }
      post :update_multiple_environment, params: params, session: set_session_user(:one)

      assert_equal hostgroup.puppet.environment_id, host1.reload.puppet.environment_id
      assert_equal hostgroup.puppet.environment_id, host2.reload.puppet.environment_id
    end

    describe '#edit' do
      setup { @routes = Rails.application.routes }

      test 'lookup value and description should be html escaped' do
        FactoryBot.create(:puppetclass_lookup_key,
          default_value: "<script>alert('hacked!');</script>",
          description: "<script>alert('hacked!');</script>",
          puppetclass: host1.puppet.puppetclasses.first)
        get :edit, params: { id: host1.to_param }, session: set_session_user
        assert_not response.body.include?('<script>alert(')
        assert_includes response.body, '&lt;script&gt;alert('
        assert_equal 2, response.body.scan('&lt;script&gt;alert(').count
      end
    end

    describe '#hostgroup_or_environment_selected' do
      let(:hostgroup) { FactoryBot.create(:hostgroup, :with_puppet_enc, organizations: [org], locations: [loc]) }

      test 'choosing only one of hostgroup or environment renders classes' do
        post :hostgroup_or_environment_selected, params: {
          host_id: nil,
          host: {
            puppet_attributes: {
              environment_id: environment1.id,
            },
          },
        }, session: set_session_user, xhr: true
        assert_response :success
        assert_template partial: 'hosts/_form_puppet_enc_tab'
      end

      test 'choosing both hostgroup and environment renders classes' do
        post :hostgroup_or_environment_selected, params: {
          host_id: host1.id,
          host: {
            hostgroup_id: hostgroup.id,
            puppet_attributes: {
              environment_id: environment1.id,
            },
          },
        }, session: set_session_user, xhr: true
        assert_response :success
        assert_template partial: 'hosts/_form_puppet_enc_tab'
      end

      test 'should not escape lookup values on environment change' do
        host = FactoryBot.create(:host, :with_puppet_enc, :with_puppetclass)

        host.environment.locations = [host.location]
        host.environment.organizations = [host.organization]

        lookup_key = FactoryBot.create(:puppetclass_lookup_key, :array, default_value: %w[a b],
                                                                        override: true,
                                                                        puppetclass: host.puppet.puppetclasses.first,
                                                                        overrides: { "fqdn=#{host.fqdn}" => %w[c d] })
        lookup_value = lookup_key.lookup_values.first

        # sending exactly what the host form would send which is lookup_value.value_before_type_cast
        lk_params = { 'lookup_values_attributes' => { lookup_key.id.to_s => { 'value' => lookup_value.value_before_type_cast,
                                                                              'id' => lookup_value.id,
                                                                              'lookup_key_id' => lookup_key.id,
                                                                              '_destroy' => false } } }
        params = {
          host_id: host.id,
          host: host.attributes.merge(lk_params),
        }

        # environment change calls puppetclass_parameters which caused the extra escaping
        post :puppetclass_parameters, params: params, session: set_session_user, xhr: true

        # if this was escaped during refresh_host the value in response.body after unescapeHTML would include "[\\\"c\\\",\\\"d\\\"]"
        assert_includes CGI.unescapeHTML(response.body), '["c","d"]'
      end
    end

    describe 'setting puppet proxy on multiple hosts' do
      test 'should change the puppet proxy' do
        proxy = FactoryBot.create(:puppet_smart_proxy)

        @request.env['HTTP_REFERER'] = '/hosts'
        params = { host_ids: [host1.id, host2.id], proxy: { proxy_id: proxy.id } }

        setup_user 'edit', 'hosts'
        post :update_multiple_puppet_proxy, params: params, session: set_session_user(:one)

        assert_empty flash[:error]

        set_admin
        [host1, host2].each do |host|
          assert_equal proxy, host.reload.puppet_proxy
        end
      end

      test 'should clear the puppet proxy of multiple hosts' do
        @request.env['HTTP_REFERER'] = '/hosts'

        params = { host_ids: [host1.id, host2.id], proxy: { proxy_id: '' } }

        setup_user 'edit', 'hosts'
        post :update_multiple_puppet_proxy, params: params, session: set_session_user(:one)

        assert_empty flash[:error]

        set_admin
        [host1, host2].each do |host|
          assert_nil host.reload.puppet_proxy
        end
      end
    end

    describe '#externalNodes' do
      test 'externalNodes should render YAML hashes correctly' do
        HostInfoProviders::PuppetInfo.any_instance.expects(:classes_info_hash).returns(
          'dhcp' => {
            'bootfiles' => [
              { 'name' => 'foo', 'mount_point' => '/bar' }.with_indifferent_access,
              { 'name' => 'john', 'mount_point' => '/doe' }.with_indifferent_access,
            ],
          }
        ).at_least_once

        get :externalNodes, params: { name: host1.name, format: 'yml' }, session: set_session_user
        assert_response :success
        enc = nil
        as_admin { enc = host1.info.deep_stringify_keys.to_yaml }
        assert_equal enc, response.body
      end

      test 'externalNodes should render correctly when format text/html is given' do
        Resolv.any_instance.stubs(:getnames).returns(['else.where'])
        get :externalNodes, params: { name: host1.name }, session: set_session_user
        assert_response :success
        as_admin { @enc = host1.info.to_yaml }
        assert_equal "<pre>#{ERB::Util.html_escape(@enc)}</pre>", response.body
      end

      test 'externalNodes should render yml request correctly' do
        Resolv.any_instance.stubs(:getnames).returns(['else.where'])
        get :externalNodes, params: { name: host1.name, format: 'yml' }, session: set_session_user
        assert_response :success
        as_admin { @enc = host1.info.deep_stringify_keys.to_yaml(line_width: -1) }
        assert_equal @enc, response.body
      end

      test 'when ":restrict_registered_smart_proxies" is false, HTTP requests should be able to get externalNodes' do
        User.current = nil
        Setting[:restrict_registered_smart_proxies] = false
        SETTINGS[:require_ssl] = false

        Resolv.any_instance.stubs(:getnames).returns(['else.where'])
        get :externalNodes, params: { name: host1.name, format: 'yml' }
        assert_response :success
      end

      test 'hosts with a registered smart proxy on should get externalNodes successfully' do
        User.current = nil
        Setting[:restrict_registered_smart_proxies] = true

        Resolv.any_instance.stubs(:getnames).returns(['else.where'])
        get :externalNodes, params: { name: host1.name, format: 'yml' }
        assert_response :success
      end

      test 'hosts without a registered smart proxy on should not be able to get externalNodes' do
        User.current = nil
        Setting[:restrict_registered_smart_proxies] = true

        Resolv.any_instance.stubs(:getnames).returns(['another.host'])
        get :externalNodes, params: { name: host1.name, format: 'yml' }
        assert_equal 403, @response.status
      end

      test 'hosts with a registered smart proxy and SSL cert should get externalNodes successfully' do
        User.current = nil
        Setting[:restrict_registered_smart_proxies] = true

        @request.env['HTTPS'] = 'on'
        @request.env['SSL_CLIENT_S_DN'] = 'CN=else.where'
        @request.env['SSL_CLIENT_VERIFY'] = 'SUCCESS'
        Resolv.any_instance.stubs(:getnames).returns(['else.where'])
        get :externalNodes, params: { name: host1.name, format: 'yml' }
        assert_response :success
      end

      test 'hosts in trusted hosts list and SSL cert should get externalNodes successfully' do
        User.current = nil
        Setting[:restrict_registered_smart_proxies] = true
        Setting[:trusted_hosts] = ['else.where']

        @request.env['HTTPS'] = 'on'
        @request.env['SSL_CLIENT_S_DN'] = 'CN=else.where'
        @request.env['SSL_CLIENT_VERIFY'] = 'SUCCESS'
        Resolv.any_instance.stubs(:getnames).returns(['else.where'])
        get :externalNodes, params: { name: host1.name, format: 'yml' }
        assert_response :success
      end

      test 'hosts with comma-separated SSL DN should get externalNodes successfully' do
        User.current = nil
        Setting[:restrict_registered_smart_proxies] = true
        Setting[:trusted_hosts] = ['foreman.example']

        @request.env['HTTPS'] = 'on'
        @request.env['SSL_CLIENT_S_DN'] = 'CN=foreman.example,OU=PUPPET,O=FOREMAN,ST=North Carolina,C=US'
        @request.env['SSL_CLIENT_VERIFY'] = 'SUCCESS'
        Resolv.any_instance.stubs(:getnames).returns(['else.where'])
        get :externalNodes, params: { name: host1.name, format: 'yml' }
        assert_response :success
      end

      test 'hosts with slash-separated SSL DN should get externalNodes successfully' do
        User.current = nil
        Setting[:restrict_registered_smart_proxies] = true
        Setting[:trusted_hosts] = ['foreman.linux.lab.local']

        @request.env['HTTPS'] = 'on'
        @request.env['SSL_CLIENT_S_DN'] = '/C=US/ST=NC/L=City/O=Example/OU=IT/CN=foreman.linux.lab.local/emailAddress=user@example.com'
        @request.env['SSL_CLIENT_VERIFY'] = 'SUCCESS'
        Resolv.any_instance.stubs(:getnames).returns(['else.where'])
        get :externalNodes, params: { name: host1.name, format: 'yml' }
        assert_response :success
      end

      test 'hosts without a registered smart proxy but with an SSL cert should not be able to get externalNodes' do
        User.current = nil
        Setting[:restrict_registered_smart_proxies] = true

        @request.env['HTTPS'] = 'on'
        @request.env['SSL_CLIENT_S_DN'] = 'CN=another.host'
        @request.env['SSL_CLIENT_VERIFY'] = 'SUCCESS'
        get :externalNodes, params: { name: host1.name, format: 'yml' }
        assert_response :forbidden
      end

      test 'hosts with an unverified SSL cert should not be able to get externalNodes' do
        User.current = nil
        Setting[:restrict_registered_smart_proxies] = true

        @request.env['HTTPS'] = 'on'
        @request.env['SSL_CLIENT_S_DN'] = 'CN=else.where'
        @request.env['SSL_CLIENT_VERIFY'] = 'FAILURE'
        get :externalNodes, params: { name: host1.name, format: 'yml' }
        assert_response :forbidden
      end

      test 'authenticated users over HTTP should be able to get externalNodes' do
        Setting[:restrict_registered_smart_proxies] = true
        SETTINGS[:require_ssl] = false

        Resolv.any_instance.stubs(:getnames).returns(['users.host'])
        get :externalNodes, params: { name: host1.name, format: 'yml' }, session: set_session_user
        assert_response :success
      end

      test 'authenticated users over HTTPS should be able to get externalNodes' do
        Setting[:restrict_registered_smart_proxies] = true
        SETTINGS[:require_ssl] = false

        Resolv.any_instance.stubs(:getnames).returns(['users.host'])
        @request.env['HTTPS'] = 'on'
        get :externalNodes, params: { name: host1.name, format: 'yml' }, session: set_session_user
        assert_response :success
      end
    end
  end
end
