require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  class HostsControllerTest < ActionController::TestCase
    tests ::HostsController

    setup do
      @routes = ForemanPuppetEnc::Engine.routes
      as_admin do
        host1
        host2
      end
    end

    let(:org) { users(:one).organizations.first }
    let(:loc) { users(:one).locations.first }
    let(:environment1) { FactoryBot.create(:environment, organizations: [org], locations: [loc]) }
    let(:environment2) { FactoryBot.create(:environment, organizations: [org], locations: [loc]) }
    let(:hostgroup) { FactoryBot.create(:hostgroup, environment: environment2, organizations: [org], locations: [loc]) }
    let(:host_defaults) { { hostgroup: hostgroup, environment: environment1, organization: org, location: loc } }
    let(:host1) { FactoryBot.create(:host, host_defaults) }
    let(:host2) { FactoryBot.create(:host, host_defaults) }

    test 'user with edit host rights with update environments should change environments' do
      @request.env['HTTP_REFERER'] = '/hosts'
      setup_user 'edit', 'hosts'

      post :update_multiple_environment, params: { host_ids: [host1.id, host2.id],
                                                   environment: { id: environment2.id } },
                                         session: set_session_user(:one)
      assert_equal environment2.id, host1.reload.environment_id
      assert_equal environment2.id, host2.reload.environment_id
      assert_equal 'Updated hosts: changed environment', flash[:success]
    end

    test 'should inherit the hostgroup environment if *inherit from hostgroup* selected' do
      @request.env['HTTP_REFERER'] = '/hosts'
      setup_user 'edit', 'hosts'

      params = { host_ids: [host1.id, host2.id], environment: { id: 'inherit' } }
      post :update_multiple_environment, params: params, session: set_session_user(:one)

      assert_equal hostgroup.environment_id, host1.reload.environment_id
      assert_equal hostgroup.environment_id, host2.reload.environment_id
    end
  end
end
