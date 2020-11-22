require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  class HostsControllerTest < ActionController::TestCase
    tests ::HostsController

    setup do
      @routes = ForemanPuppetEnc::Engine.routes
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

      assert_equal hostgroup.environment_id, host1.reload.environment_id
      assert_equal hostgroup.environment_id, host2.reload.environment_id
    end

    describe '#edit' do
      setup { @routes = Rails.application.routes }

      test 'lookup value and description should be html escaped' do
        skip 'Needs complete migration to be done' unless ForemanPuppetEnc.extracted_from_core?
        host = FactoryBot.create(:host, :with_puppetclass)
        FactoryBot.create(:puppetclass_lookup_key,
          default_value: "<script>alert('hacked!');</script>",
          description: "<script>alert('hacked!');</script>",
          puppetclass: host1.puppetclasses.first)
        get :edit, params: { id: host.to_param }, session: set_session_user
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
                                                                        puppetclass: host.puppetclasses.first,
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
  end
end
