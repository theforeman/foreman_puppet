require 'test_puppet_helper'

module Queries
  class EnvironmentQueryTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query (
        $id: String!
      ) {
        environment(id: $id) {
          id
          createdAt
          updatedAt
          name
          locations {
            totalCount
            edges {
              node {
                id
              }
            }
          }
          organizations {
            totalCount
            edges {
              node {
                id
              }
            }
          }
        }
      }
      GRAPHQL
    end

    let(:environment) { FactoryBot.create(:environment) }

    let(:global_id) { Foreman::GlobalId.for(environment) }
    let(:variables) { { id: global_id } }
    let(:data) { result['data']['environment'] }

    test 'fetching environment attributes' do
      assert_empty result['errors']

      expect(data['name']).must_equal(environment.name)
      expect(data['id']).must_equal(global_id)
      expect(data['createdAt']).must_equal(environment.created_at.utc.iso8601)
      expect(data['updatedAt']).must_equal(environment.updated_at.utc.iso8601)

      assert_collection environment.locations, data['locations']
      assert_collection environment.organizations, data['organizations']
    end
  end
end
