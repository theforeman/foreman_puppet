require 'test_puppet_helper'

module ForemanPuppet
  module Api
    module V2
      class ProvisioningTemplatesControllerTest < ActionController::TestCase
        tests ::Api::V2::ProvisioningTemplatesController

        let(:environment) { FactoryBot.create(:environment) }

        test 'should create provisioning template with template_combinations' do
          name = RFauxFactory.gen_alpha
          valid_attrs = {
            name: name, template: RFauxFactory.gen_alpha, template_kind_id: template_kinds(:ipxe).id,
            template_combinations_attributes: [
              { hostgroup_id: hostgroups(:common).id, environment_id: environment.id },
            ]
          }
          post :create, params: { provisioning_template: valid_attrs }
          assert_response :created
          response = ActiveSupport::JSON.decode(@response.body)
          assert response.key?('id')
          assert response.key?('template_combinations')
          template_combinations = response['template_combinations']
          assert_equal 1, template_combinations.length
          template_combination = TemplateCombination.find(template_combinations[0]['id'])
          assert_equal response['id'], template_combination.provisioning_template_id
        end
      end
    end
  end
end
