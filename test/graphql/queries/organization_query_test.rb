require 'test_puppet_helper'

module Queries
  class OrganizationQueryTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query (
        $id: String!
      ) {
        organization(id: $id) {
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
    let(:organization_object) { FactoryBot.create(:organization, environments: [environment]) }

    let(:global_id) { Foreman::GlobalId.for(organization_object) }
    let(:variables) { { id: global_id } }
    let(:data) { result['data']['organization'] }

    setup do
      FactoryBot.create(:puppetclass, environments: [environment])
    end

    test 'fetching organization attributes' do
      assert_empty result['errors']

      assert_equal global_id, data['id']
      assert_collection organization_object.environments, data['environments']
      assert_collection organization_object.puppetclasses, data['puppetclasses']
    end
  end
end
