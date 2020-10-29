require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  module Api
    module V2
      class HostgroupsControllerTest < ActionController::TestCase
        tests ::Api::V2::HostgroupsController

        let(:hostgroup) { FactoryBot.create(:hostgroup, :with_puppet_enc) }

        describe '#show' do
          test 'include config_groups' do
            skip 'needs https://github.com/theforeman/foreman/pull/8115' unless ForemanPuppetEnc.extracted_from_core?
            get :show, params: { id: hostgroup.to_param }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(response.body)
            assert json_response['config_groups'].is_a? Array
            response_cg_ids = json_response['config_groups'].map { |cg| cg['id'] }
            assert_equal hostgroup.puppet.config_groups.pluck(:id), response_cg_ids
          end
        end
      end
    end
  end
end
