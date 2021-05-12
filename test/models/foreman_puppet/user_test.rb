require 'test_puppet_helper'

module ForemanPuppet
  class UserTest < ActiveSupport::TestCase
    describe '#visible_environments' do
      let(:environment) { FactoryBot.create(:environment) }
      setup { environment }

      # These will need refactor when the environment fixtures will be gone
      test 'should show the list of environments visible as admin user' do
        # Admin user sees all environments - including the ones without taxonomies
        env_names = %w[production global_puppetmaster testing] + [environment.name]
        assert_equal env_names.sort, ::User.current.visible_environments.sort
      end

      test 'should show the list of environments visible as inherited admin user' do
        ::User.current = FactoryBot.create(:user, usergroups: [FactoryBot.create(:usergroup, admin: true)]).reload
        env_names = %w[production global_puppetmaster testing] + [environment.name]
        assert_same_elements env_names, ::User.current.visible_environments
      end

      test 'should show the list of environments visible as non-admin user' do
        # Non-admin user only sees environments in a taxonomy at least
        setup_user 'view', 'environments'
        assert_equal [environment.name], ::User.current.visible_environments
      end
    end
  end
end
