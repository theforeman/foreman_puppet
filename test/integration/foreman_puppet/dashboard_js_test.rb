require 'integration_puppet_helper'
require 'integration/shared/host_finders'
require 'integration/shared/host_orchestration_stubs'

module ForemanPuppet
  class DashboardJSTest < IntegrationTestWithJavascript
    setup do
      Dashboard::Manager.reset_user_to_default(users(:admin))
      Setting[:outofsync_interval] = 35
    end

    context 'with origin' do
      setup do
        Setting[:puppet_out_of_sync_disabled] = true
      end

      context 'out of sync disabled' do
        test 'has no out of sync link' do
          visit dashboard_path
          wait_for_ajax
          within "li[data-name='Host Configuration Status for Puppet']" do
            assert page.has_no_link?('Out of sync hosts')
            assert page.has_no_link?('Good host reports in the last')
            assert page.has_link?('Good host with reports')
          end
        end
      end
    end
  end
end
