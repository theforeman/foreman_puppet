require 'test_puppet_helper'
module ForemanPuppet
  module Api
    module V2
      class ConfigGroupsControllerTest < ActionController::TestCase
        setup do
          @routes = ForemanPuppet::Engine.routes
        end

        let(:puppetclasses) { FactoryBot.create_list(:puppetclass, 2) }
        let(:config_group) { FactoryBot.create(:config_group) }

        test 'should create config group' do
          assert_difference('ConfigGroup.count') do
            post :create, params: { config_group: { name: 'config-group', puppetclass_ids: puppetclasses.map(&:id) } }
          end
          assert_response :created
        end

        test 'should update config group' do
          name = 'new name'
          put :update, params: { id: config_group.to_param,
                                 config_group: { name: name,
                                                 puppetclass_ids: puppetclasses.map(&:id) } }
          assert_response :success
          response = JSON.parse(@response.body)
          assert_equal 2, response['puppetclasses'].count
        end
      end
    end
  end
end
