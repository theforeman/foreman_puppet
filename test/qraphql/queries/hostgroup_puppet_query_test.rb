require 'test_puppet_helper'

module Queries
  class HostgroupPuppetQueryTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query (
        $id: String!
      ) {
        hostgroup(id: $id) {
          id
          environment {
            id
          }
          puppetProxy {
            id
          }
        }
      }
      GRAPHQL
    end

    let(:hostgroup) { FactoryBot.create(:hostgroup, :with_puppet_enc) }
    let(:global_id) { Foreman::GlobalId.encode('Hostgroup', hostgroup.id) }
    let(:variables) { { id: global_id } }

    test 'fetching host attributes' do
      skip 'GraphQL is TODO'
      hostgroup_data = result['data']['hostgroup']
      assert_empty result['errors']
      assert_equal global_id, hostgroup_data['id']
      assert_record hostgroup.puppet.environment, hostgroup_data['environment']
      assert_record hostgroup.puppet_proxy, hostgroup_data['puppetProxy']
    end
  end
end
