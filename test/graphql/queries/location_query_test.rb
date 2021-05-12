require 'test_puppet_helper'

module Queries
  class LocationQueryTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query (
        $id: String!
      ) {
        location(id: $id) {
          id
          environments {
            totalCount
            edges {
              node {
                id
              }
            }
          }
          puppetclasses {
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
    let(:location_object) { FactoryBot.create(:location, environments: [environment]) }

    let(:global_id) { Foreman::GlobalId.for(location_object) }
    let(:variables) { { id: global_id } }
    let(:data) { result['data']['location'] }

    setup do
      FactoryBot.create(:puppetclass, environments: [environment])
    end

    test 'fetching location attributes' do
      assert_empty result['errors']

      assert_equal global_id, data['id']
      assert_collection location_object.environments, data['environments']
      assert_collection location_object.puppetclasses, data['puppetclasses']
    end
  end
end
