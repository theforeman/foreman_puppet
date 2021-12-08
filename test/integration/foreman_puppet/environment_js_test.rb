require 'integration_puppet_helper'

module ForemanPuppet
  class EnvironmentJSTest < IntegrationTestWithJavascript
    include ForemanPuppet::Engine.routes.url_helpers

    let(:environment) { FactoryBot.create(:environment) }
    setup { environment }

    test 'index page' do
      assert_index_page(environments_path, 'Environments', 'Create Puppet Environment')
    end

    test 'create new page' do
      assert_new_button(environments_path, 'Create Puppet Environment', new_environment_path)
      fill_in 'environment_name', with: 'golive'
      assert_submit_button(environments_path)
      assert page.has_link? 'golive'
    end

    test 'edit page' do
      visit environments_path
      click_link environment.name
      fill_in 'environment_name', with: 'production222'
      assert_submit_button(environments_path)
      assert page.has_link? 'production222'
    end
  end
end
