require 'test_puppet_helper'

class ProvisioningTemplatesControllerTest < ActionController::TestCase
  let(:environment) { FactoryBot.create(:environment) }
  let(:template_combination) { FactoryBot.create(:template_combination, environment: environment) }

  context 'templates combinations' do
    test 'can be added on template creation' do
      template_combination = { environment_id: environment.id,
                               hostgroup_id: hostgroups(:db).id }
      provisioning_template = {
        name: 'foo',
        template: '#nocontent',
        template_kind_id: TemplateKind.find_by(name: 'iPXE').id,
        template_combinations_attributes: { '3923' => template_combination },
      }
      assert_difference('TemplateCombination.unscoped.count', 1) do
        assert_difference('ProvisioningTemplate.unscoped.count', 1) do
          post :create, params: {
            provisioning_template: provisioning_template,
          }, session: set_session_user
        end
      end
    end

    context 'for already existing templates' do
      test 'can be edited' do
        new_environment = FactoryBot.create(:environment)
        template = template_combination.provisioning_template
        assert_not_equal new_environment, template_combination.environment
        put :update, params: {
          id: template.to_param,
          provisioning_template: {
            template_combinations_attributes: {
              '0' => {
                id: template_combination.id,
                environment_id: new_environment.id,
                hostgroup_id: template_combination.hostgroup.id,
              },
            },
          },
        }, session: set_session_user
        assert_response :found
        as_admin do
          template_combination.reload
          assert_equal new_environment, template_combination.environment
        end
      end

      test 'can be destroyed' do
        # create prior the request
        template_combination
        assert_difference('TemplateCombination.count', -1) do
          put :update, params: {
            id: template_combination.provisioning_template.to_param,
            provisioning_template: {
              template_combinations_attributes: {
                '0' => {
                  id: template_combination.id,
                  _destroy: 1,
                },
              },
            },
          }, session: set_session_user
        end
        assert_response :found
      end
    end
  end
end
