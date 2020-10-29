require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  module Api
    module V2
      class HostsControllerTest < ActionController::TestCase
        tests ::Api::V2::HostsController

        let(:host) { FactoryBot.create(:host, :with_puppet_enc) }

        describe '#show' do
          test 'include config_groups' do
            get :show, params: { id: host.to_param }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(response.body)
            assert json_response['config_groups'].is_a? Array
            response_cg_ids = json_response['config_groups'].map { |cg| cg['id'] }
            assert_equal host.puppet.config_groups.pluck(:id), response_cg_ids
          end
        end
      end
    end
  end
end
