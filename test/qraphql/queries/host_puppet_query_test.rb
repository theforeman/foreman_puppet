require 'test_puppet_enc_helper'

module Queries
  class HostPuppetQueryTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query (
        $id: String!
      ) {
        host(id: $id) {
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

    let(:host) { FactoryBot.create(:host, :with_puppet_enc) }
    let(:global_id) { Foreman::GlobalId.encode('Host', host.id) }
    let(:variables) { { id: global_id } }

    test 'fetching host attributes' do
      host_data = result['data']['host']
      assert_empty result['errors']
      assert_equal global_id, host_data['id']
      assert_record host.environment, host_data['environment']
      assert_record host.puppet_proxy, host_data['puppetProxy']
    end
  end
end
