require 'test_puppet_helper'

module ForemanPuppet
  module Mutations
    module Hosts
      class CreateMutationTest < GraphQLQueryTestCase
        let(:hostname) { 'my-graphql-host' }
        let(:tax_location) { FactoryBot.create(:location) }
        let(:organization) { FactoryBot.create(:organization) }
        let(:environment) { FactoryBot.create(:environment, locations: [tax_location], organizations: [organization]) }
        let(:environment_id) { Foreman::GlobalId.for(environment) }
        let(:puppetclass) { FactoryBot.create(:puppetclass) }
        let(:puppetclass_id) { Foreman::GlobalId.for(puppetclass) }

        let(:variables) do
          {
            name: hostname,
            environmentId: environment_id,
            puppetclassIds: [puppetclass_id],
          }
        end
        let(:context_user) { FactoryBot.create(:user, :admin, locations: [tax_location], organizations: [organization]) }
        let(:data) { result['data']['createHost']['host'] }

        let(:query) do
          <<-GRAPHQL
            mutation createHostMutation(
                $name: String!,
                $environmentId: ID,
                $puppetclassIds: [ID!],
              ) {
              createHost(input: {
                name: $name,
                environmentId: $environmentId,
                puppetclassIds: $puppetclassIds,
              }) {
                host {
                  id
                },
                errors {
                  path
                  message
                }
              }
            }
          GRAPHQL
        end

        setup :disable_orchestration

        it 'creates a host with puppet parameters' do
          assert_difference(-> { Host.count }, +1) do
            assert_empty result['errors']
            assert_empty result['data']['createHost']['errors']

            host = Host.find(Foreman::GlobalId.decode(data['id'])[2])
            assert_equal environment.id, host.puppet.environment_id
            assert_equal [puppetclass.id], host.puppet.puppetclasses.pluck(:id)

            assert_not_nil data
          end
        end
      end
    end
  end
end
