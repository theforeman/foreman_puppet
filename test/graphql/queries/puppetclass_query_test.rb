require 'test_puppet_helper'

module Queries
  class PuppetclassQueryTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query (
        $id: String!
      ) {
        puppetclass(id: $id) {
          id
          createdAt
          updatedAt
          name
          environments {
            totalCount
            edges {
              node {
                id
              }
            }
          }
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
    let(:puppetclass) { FactoryBot.create(:puppetclass) }

    let(:global_id) { Foreman::GlobalId.for(puppetclass) }
    let(:variables) { { id: global_id } }
    let(:data) { result['data']['puppetclass'] }

    setup do
      FactoryBot.create(:environment_class, puppetclass: puppetclass, environment: environment)
    end

    test 'fetching puppetclass attributes' do
      assert_empty result['errors']

      expect(data['id']).must_equal global_id
      expect(data['createdAt']).must_equal puppetclass.created_at.utc.iso8601
      expect(data['updatedAt']).must_equal puppetclass.updated_at.utc.iso8601
      expect(data['name']).must_equal puppetclass.name

      assert_collection puppetclass.environments, data['environments']
      assert_collection puppetclass.locations, data['locations']
      assert_collection puppetclass.organizations, data['organizations']
    end
  end
end
