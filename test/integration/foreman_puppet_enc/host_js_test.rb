require 'test_puppet_enc_helper'
require 'integration_test_helper'
require 'integration/shared/host_finders'
require 'integration/shared/host_orchestration_stubs'

module ForemanPuppetEnc
  class HostJSTest < IntegrationTestWithJavascript
    include HostFinders
    include HostOrchestrationStubs

    let(:host) { FactoryBot.create(:host, :with_puppet_enc, :managed) }
    let(:org) { Organization.find_by(name: 'Organization 1') }
    let(:loc) { Location.find_by(name: 'Location 1') }

    describe 'new host page' do
      test 'choosing a hostgroup overrides other host attributes' do
        original_hostgroup = FactoryBot
                             .create(:hostgroup, environment: FactoryBot.create(:environment))
        overridden_hostgroup = FactoryBot
                               .create(:hostgroup, environment: FactoryBot.create(:environment))

        visit new_host_path
        select2(original_hostgroup.name, from: 'host_hostgroup_id')
        wait_for_ajax
        click_on_inherit('environment')
        select2(overridden_hostgroup.name, from: 'host_hostgroup_id')
        assert page.find('#s2id_host_environment_id .select2-chosen').has_text? overridden_hostgroup.environment.name
      end

      test 'sets fields to "inherit" when hostgroup is selected' do
        env1 = FactoryBot.create(:environment, organizations: [org], locations: [loc])
        env2 = FactoryBot.create(:environment, organizations: [org], locations: [loc])
        hg = FactoryBot.create(:hostgroup, environment: env2)
        os = FactoryBot.create(:ubuntu14_10, :with_associations)
        disable_orchestration
        visit new_host_path

        fill_in 'host_name', with: 'myhost1'
        select2 'Organization 1', from: 'host_organization_id'
        wait_for_ajax
        select2 'Location 1', from: 'host_location_id'
        wait_for_ajax
        select2 env1.name, from: 'host_environment_id'
        select2 hg.name, from: 'host_hostgroup_id'
        wait_for_ajax

        click_link 'Operating System'
        select2 os.architectures.first.name, from: 'host_architecture_id'
        select2 os.title, from: 'host_operatingsystem_id'
        uncheck('host_build')

        select2 os.media.first.name, from: 'host_medium_id'
        select2 os.ptables.first.name, from: 'host_ptable_id'
        fill_in 'host_root_pass', with: '12345678'

        switch_form_tab_to_interfaces
        click_button 'Edit'
        select2 domains(:mydomain).name, from: 'host_interfaces_attributes_0_domain_id'
        fill_in 'host_interfaces_attributes_0_mac', with: '00:11:11:11:11:11'
        fill_in 'host_interfaces_attributes_0_ip', with: '2.3.4.44'

        close_interfaces_modal

        click_on_submit

        host = Host::Managed.search_for('name ~ "myhost1"').first
        assert_equal env2.name, host.environment.name
      end

      test 'saves correct values for inherited fields without hostgroup' do
        env = FactoryBot.create(:environment, organizations: [org], locations: [loc])
        os = FactoryBot.create(:ubuntu14_10, :with_associations)
        Nic::Managed.any_instance.stubs(:dns_conflict_detected?).returns(true)
        visit new_host_path

        fill_in 'host_name', with: 'myhost1'
        select2 'Organization 1', from: 'host_organization_id'
        wait_for_ajax
        select2 'Location 1', from: 'host_location_id'
        wait_for_ajax
        select2 env.name, from: 'host_environment_id'

        click_link 'Operating System'
        wait_for_ajax
        select2 os.architectures.first.name, from: 'host_architecture_id'
        select2 os.title, from: 'host_operatingsystem_id'
        uncheck('host_build')
        select2 os.media.first.name, from: 'host_medium_id'
        select2 os.ptables.first.name, from: 'host_ptable_id'
        fill_in 'host_root_pass', with: '12345678'

        switch_form_tab_to_interfaces
        click_button 'Edit'
        select2 domains(:mydomain).name, from: 'host_interfaces_attributes_0_domain_id'
        fill_in 'host_interfaces_attributes_0_mac', with: '00:11:11:11:11:11'
        fill_in 'host_interfaces_attributes_0_ip', with: '1.1.1.1'
        close_interfaces_modal
        click_on_submit
        find('#host-show') # wait for host details page

        host = Host::Managed.search_for('name ~ "myhost1"').first
        assert_equal env.name, host.environment.name
      end
    end

    describe 'edit page' do
      test 'environment is not inherited on edit' do
        env1 = FactoryBot.create(:environment, organizations: [org], locations: [loc])
        env2 = FactoryBot.create(:environment, organizations: [org], locations: [loc])
        hg = FactoryBot.create(:hostgroup, environment: env2)
        host = FactoryBot.create(:host, :with_puppet_enc, hostgroup: hg)
        visit edit_host_path(host)

        select2 env1.name, from: 'host_environment_id'
        click_on_submit

        host.reload
        assert_equal env1.name, host.environment.name
      end

      test 'choosing a hostgroup does not override other host attributes' do
        original_hostgroup = FactoryBot
                             .create(:hostgroup, environment: FactoryBot.create(:environment),
                                                 puppet_proxy: FactoryBot.create(:puppet_smart_proxy))

        # Make host inherit hostgroup environment
        host.attributes = host.apply_inherited_attributes(
          'hostgroup_id' => original_hostgroup.id
        )
        host.save

        overridden_hostgroup = FactoryBot
                               .create(:hostgroup, environment: FactoryBot.create(:environment))

        visit edit_host_path(host)
        select2(original_hostgroup.name, from: 'host_hostgroup_id')

        assert_equal original_hostgroup.puppet_proxy.name, find('#s2id_host_puppet_proxy_id .select2-chosen').text

        click_on_inherit('puppet_proxy')
        select2(overridden_hostgroup.name, from: 'host_hostgroup_id')

        assert find('#s2id_host_environment_id .select2-chosen').has_text? original_hostgroup.environment.name

        # On host group change, the disabled select will be reset to an empty value - disabled select2 is invisible on chrome
        assert find('#s2id_host_puppet_proxy_id .select2-chosen', visible: :all).has_text? ''
      end

      context 'has inherited Puppetclasses' do
        test 'has the hostgroup inherited parameters visible' do
          hostgroup = FactoryBot.create(:hostgroup, :with_puppetclass)
          host = FactoryBot.create(:host, hostgroup: hostgroup, environment: hostgroup.environment)

          visit edit_host_path(host)
          switch_form_tab('Puppet ENC')

          header_element = page.find('#puppet_enc_tab .panel h3 a')
          assert header_element.text =~ /#{hostgroup.name}$/
          header_element.click

          class_element = page.find('#inherited_ids > li')
          assert_equal hostgroup.puppetclasses.first.name, class_element.text
        end
      end

      describe 'Puppetclass Params' do
        let(:host) { FactoryBot.create(:host, :with_puppet_enc, :with_puppetclass) }

        test 'shows errors on invalid lookup values' do
          lookup_key = FactoryBot.create(:puppetclass_lookup_key,
            key_type: 'real', default_value: true, path: "fqdn\ncomment",
            puppetclass: host.puppetclasses.first, overrides: { host.lookup_value_matcher => false })

          visit edit_host_path(host)
          switch_form_tab('Puppet ENC')
          assert page.has_no_selector?('#puppet_klasses_parameters td.has-error')

          fill_in "host_lookup_values_attributes_#{lookup_key.id}_value", with: 'invalid'
          click_button('Submit')
          assert page.has_selector?('#puppet_klasses_parameters td.has-error')
        end

        test 'correctly show hash type overrides' do
          FactoryBot.create(:puppetclass_lookup_key, :hash,
            default_value: 'a: b', path: "fqdn\ncomment",
            puppetclass: host.puppetclasses.first,
            overrides: { host.lookup_value_matcher => 'a: c' })

          visit edit_host_path(host)
          switch_form_tab('Puppet ENC')
          assert_equal("a: c\n", puppetclass_params.find('textarea').value)
        end

        test 'class parameters and overrides are displayed correctly for booleans' do
          lookup_key = FactoryBot.create(:puppetclass_lookup_key,
            key_type: 'boolean', default_value: 'false', path: 'fqdn',
            puppetclass: host.puppetclasses.first, overrides: { host.lookup_value_matcher => 'false' })
          visit edit_host_path(host)
          switch_form_tab('Puppet ENC')
          assert puppetclass_params.has_selector?("a[data-tag='remove']", visible: :visible)
          assert puppetclass_params.has_selector?("a[data-tag='override']", visible: :hidden)
          assert_equal('false', find("#s2id_host_lookup_values_attributes_#{lookup_key.id}_value .select2-chosen").text)
          select2 'true', from: "host_lookup_values_attributes_#{lookup_key.id}_value"
          click_on_submit

          visit edit_host_path(host)
          switch_form_tab('Puppet ENC')
          assert_equal('true', find("#s2id_host_lookup_values_attributes_#{lookup_key.id}_value .select2-chosen").text)
        end

        test 'class parameters and overrides are displayed correctly for strings' do
          FactoryBot.create(:puppetclass_lookup_key, default_value: 'default', path: 'fqdn',
                                                     puppetclass: host.puppetclasses.first, overrides: { host.lookup_value_matcher => 'hostOverride' })
          visit edit_host_path(host)
          switch_form_tab('Puppet ENC')
          assert_equal('hostOverride', puppetclass_params.find('textarea').value)
          assert puppetclass_params.find('textarea:enabled')
          puppetclass_params.find("a[data-tag='remove']").click
          assert puppetclass_params.find('textarea:disabled')
          click_on_submit

          visit edit_host_path(host)
          switch_form_tab('Puppet ENC')
          assert_equal('default', puppetclass_params.find('textarea').value)
          assert puppetclass_params.find('textarea:disabled')
          puppetclass_params.find("a[data-tag='override']").click
          assert puppetclass_params.find('textarea:enabled')
          puppetclass_params.find('textarea').set('userCustom')
          click_on_submit

          visit edit_host_path(host)
          switch_form_tab('Puppet ENC')
          assert_equal('userCustom', puppetclass_params.find('textarea').value)
          assert puppetclass_params.find('textarea:enabled')
        end

        test 'can override puppetclass lookup values' do
          FactoryBot.create(:puppetclass_lookup_key, default_value: 'default', path: 'fqdn',
                                                     puppetclass: host.puppetclasses.first, overrides: { host.lookup_value_matcher => 'hostOverride' })

          visit edit_host_path(host)
          switch_form_tab('Puppet ENC')
          assert puppetclass_params.has_selector?("a[data-tag='remove']", visible: :visible)
          assert puppetclass_params.has_selector?("a[data-tag='override']", visible: :hidden)
          assert_equal('hostOverride', puppetclass_params.find('textarea').value)
          assert puppetclass_params.find('textarea:enabled')

          puppetclass_params.find("a[data-tag='remove']").click
          assert puppetclass_params.has_selector?("a[data-tag='remove']", visible: :hidden)
          assert puppetclass_params.has_selector?("a[data-tag='override']", visible: :visible)
          assert_equal('default', puppetclass_params.find('textarea').value)
          assert puppetclass_params.find('textarea:disabled')

          puppetclass_params.find("a[data-tag='override']").click
          assert puppetclass_params.has_selector?("a[data-tag='remove']", visible: :visible)
          assert puppetclass_params.has_selector?("a[data-tag='override']", visible: :hidden)
          assert_equal('default', puppetclass_params.find('textarea').value)
          assert puppetclass_params.find('textarea:enabled')
        end

        context 'with non-admin user' do
          test 'user without edit_params permission can save host with params' do
            FactoryBot.create(:puppetclass_lookup_key,
              default_value: 'string1', path: "fqdn\ncomment",
              puppetclass: host.puppetclasses.first,
              overrides: { host.lookup_value_matcher => 'string2' })
            user = FactoryBot.create(:user, :with_mail, roles: roles(:viewer, :edit_hosts))
            assert_not user.can? 'edit_params'
            set_request_user(user)
            visit edit_host_path(host)
            switch_form_tab('Puppet ENC')
            assert puppetclass_params.find('textarea').disabled?
            click_button('Submit')
            assert page.has_link?('Edit')
          end
        end

        test 'selecting domain updates puppetclass parameters' do
          disable_orchestration
          domain = FactoryBot.create(:domain)
          FactoryBot.create(:puppetclass_lookup_key, path: "fqdn\ndomain\ncomment",
                                                     puppetclass: host.puppetclasses.first, default_value: 'default',
                                                     overrides: { "domain=#{domain.name}" => 'domain' })

          visit edit_host_path(host)
          switch_form_tab('Puppet ENC')
          assert_equal('default', puppetclass_params.find('textarea').value)

          switch_form_tab_to_interfaces
          table.first(:button, 'Edit').click

          select2 domain.name, from: 'host_interfaces_attributes_0_domain_id'
          modal.find(:button, 'Ok').click

          switch_form_tab('Puppet ENC')
          assert_equal 'domain', puppetclass_params.find('textarea').value
        end
      end
    end

    describe 'clone page' do
      test 'clones lookup values' do
        host = FactoryBot.create(:host, :with_puppetclass)
        lookup_key = FactoryBot.create(:puppetclass_lookup_key, puppetclass: host.puppetclasses.first,
                                                                path: "fqdn\ncomment",
                                                                overrides: { host.lookup_value_matcher => 'abc' })
        visit clone_host_path(host)
        switch_form_tab('Puppet ENC')
        a = page.find("#host_lookup_values_attributes_#{lookup_key.id}_value")
        assert_equal 'abc', a.value
      end
    end

    describe 'hosts index multiple actions' do
      setup do
        @entries = Setting[:entries_per_page]
        hosts
      end

      teardown do
        Setting[:entries_per_page] = @entries
      end

      let(:environment) { FactoryBot.create(:environment) }
      let(:hosts) { FactoryBot.create_list(:host, 3) }

      test 'apply bulk action, change environment on all hosts' do
        environment
        Setting[:entries_per_page] = 3
        visit hosts_path(per_page: 2)
        check 'check_all'
        find('#multiple-alert > .text > a').click
        find('#submit_multiple').click
        find('a', text: /\AChange Environment\z/).click
        find('#environment_id').find("option[value='#{environment.id}']").select_option
        find('button', text: /\ASubmit\z/).click
        assert page.has_text?(:all, 'Updated hosts: changed environment')
      end

      test 'redirect js' do
        visit hosts_path
        check 'check_all'

        # Ensure and wait for all hosts to be checked, and that no unchecked hosts remain
        assert page.has_no_selector?('input.host_select_boxes:not(:checked)')

        # Hosts are added to cookie
        host_ids_on_cookie = JSON.parse(CGI.unescape(get_me_the_cookie('_ForemanSelectedhosts')&.fetch(:value)))
        assert_includes(host_ids_on_cookie, hosts.first.id)

        page.execute_script("tfm.hosts.table.buildRedirect('#{foreman_puppet_enc.select_multiple_environment_hosts_path}')")
        assert_current_path(foreman_puppet_enc.select_multiple_environment_hosts_path, ignore_query: true)

        assert page.has_selector?('td', text: hosts.first.name)
      end
    end

    private

    def puppetclass_params
      page.find('#puppet_klasses_parameters_table')
    end

    # TODO: unless ForemanPuppetEnc.extracted_from_core?
    def switch_form_tab_to_interfaces
      switch_form_tab('Interfaces')
      disable_interface_modal_animation
    end
  end
end
