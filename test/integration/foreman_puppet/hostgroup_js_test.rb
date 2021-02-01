require 'test_puppet_helper'
require 'integration_test_helper'

module ForemanPuppet
  class HostgroupJSTest < IntegrationTestWithJavascript
    let(:hostgroup) { FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass) }
    let(:environment) { FactoryBot.create(:environment) }

    describe 'create new page' do
      test 'create new page' do
        environment
        assert_new_button(hostgroups_path, 'Create Host Group', new_hostgroup_path)
        fill_in 'hostgroup_name', with: 'staging'
        select2 environment.name, from: 'hostgroup_puppet_attributes_environment_id'
        assert_submit_button(hostgroups_path)
        assert_equal environment.id,
          Hostgroup.find_by(name: 'staging').environment_id,
          'Hostgroup not created or environment not set'
      end
    end

    describe 'edit page' do
      setup do
        @another_puppetclass = FactoryBot.create(:puppetclass)
      end

      describe 'changing the environment' do
        setup do
          environment
          @hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc)
          visit hostgroups_path
          click_link @hostgroup.name
        end

        test 'preserves the puppetclasses' do
          puppetclasses = @hostgroup.puppet.puppetclasses.all

          select2 environment.name, from: 'hostgroup_puppet_attributes_environment_id'
          assert_submit_button(hostgroups_path)

          assert_equal puppetclasses, @hostgroup.puppet.puppetclasses.all
        end
      end

      context 'has inherited Puppetclasses' do
        test 'has the parent group inherited parameters visible' do
          child_hostgroup = FactoryBot.create(:hostgroup, parent: hostgroup)

          visit edit_hostgroup_path(child_hostgroup)
          switch_form_tab('Puppet ENC')

          header_element = page.find('#puppet_enc_tab .panel h3 a')
          assert header_element.text =~ /#{hostgroup.name}$/
          header_element.click

          class_element = page.find('#inherited_ids > li')
          assert_equal hostgroup.puppet.puppetclasses.first.name, class_element.text
        end
      end

      test 'shows errors on invalid lookup values' do
        lookup_key = FactoryBot.create(:puppetclass_lookup_key, :integer,
          path: 'hostgroup', puppetclass: hostgroup.puppet.puppetclasses.first,
          overrides: { hostgroup.lookup_value_matcher => 2 })

        visit edit_hostgroup_path(hostgroup)
        switch_form_tab('Puppet ENC')
        assert page.has_no_selector?('#puppet_klasses_parameters .input-group.has-error')
        fill_in "hostgroup_lookup_values_attributes_#{lookup_key.id}_value", with: 'invalid'
        click_button('Submit')
        assert page.has_selector?('#puppet_klasses_parameters td.has-error')
      end

      context 'puppet classes are not available in the environment' do
        test 'it shows a warning and marks as unavailable' do
          hostgroup.puppet.puppetclasses << @another_puppetclass
          visit edit_hostgroup_path(hostgroup)

          switch_form_tab('Puppet ENC')

          assert page.has_selector?('#puppetclasses_unavailable_warning')
          assert page.has_selector?('.selected_puppetclass.unavailable')
        end
      end
    end

    describe 'clone page' do
      test 'clones lookup values' do
        lookup_key = FactoryBot.create(:puppetclass_lookup_key, path: "hostgroup\ncomment",
                                                                puppetclass: hostgroup.puppet.puppetclasses.first,
                                                                overrides: { hostgroup.lookup_value_matcher => 'abc' })

        visit clone_hostgroup_path(hostgroup)
        switch_form_tab('Puppet ENC')
        a = page.find("#hostgroup_lookup_values_attributes_#{lookup_key.id}_value")
        assert_equal 'abc', a.value
      end
    end
  end
end
