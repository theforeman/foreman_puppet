require 'test_puppet_helper'
require 'integration_test_helper'

module ForemanPuppet
  class PuppetclassJsTest < IntegrationTestWithJavascript
    include ForemanPuppet::Engine.routes.url_helpers
    # intermittent failures:
    #   PuppetclassIntegrationTest.test_0001_edit page

    let(:environment) { FactoryBot.create(:environment) }
    let(:puppetclass) { FactoryBot.create(:puppetclass, environments: [environment]) }

    test 'edit page' do
      FactoryBot.create(:puppetclass, name: 'vim', environments: [environment]) if ForemanPuppet.extracted_from_core?
      visit puppetclasses_path
      click_link 'vim'
      assert page.has_no_link? 'Common'
      find(:xpath, "//a[@title='Select All']").hover
      find(:xpath, "//a[@data-original-title='Select All']").click
      assert_submit_button(puppetclasses_path)
      assert page.has_link? 'vim'
      assert page.has_link? 'Common'
    end

    test 'verify key label exists in case key is too long' do
      smart_class_parameter_long = FactoryBot.create(:puppetclass_lookup_key, puppetclass: puppetclass, variable: 'a' * 50)
      visit edit_puppetclass_path(puppetclass)
      click_link 'Smart Class Parameter'
      page.find("#pill_#{smart_class_parameter_long.id}-#{smart_class_parameter_long.key}").hover
      assert_equal smart_class_parameter_long.key, page.find("#pill_#{smart_class_parameter_long.id}-#{smart_class_parameter_long.key}")['data-original-title']
    end

    test 'verify key label is empty in case key is short' do
      smart_class_parameter_short = FactoryBot.create(:puppetclass_lookup_key, puppetclass: puppetclass, variable: 'a' * 40)
      visit edit_puppetclass_path(puppetclass)
      click_link 'Smart Class Parameter'
      page.find("#pill_#{smart_class_parameter_short.id}-#{smart_class_parameter_short.key}").hover
      assert_empty page.find("#pill_#{smart_class_parameter_short.id}-#{smart_class_parameter_short.key}")['data-original-title']
    end
  end
end
