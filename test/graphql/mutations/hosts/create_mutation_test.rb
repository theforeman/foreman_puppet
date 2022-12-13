require 'test_puppet_helper'

module ForemanPuppet
  module Mutations
    module Hosts
      class CreateMutationTest < GraphQLQueryTestCase
        let(:hostname) { 'my-graphql-host' }
        let(:tax_location) { FactoryBot.create(:location) }
        let(:location_id) { Foreman::GlobalId.for(tax_location) }
        let(:organization) { FactoryBot.create(:organization) }
        let(:organization_id) { Foreman::GlobalId.for(organization) }
        let(:domain) { FactoryBot.create(:domain) }
        let(:domain_id) { Foreman::GlobalId.for(domain) }
        let(:operatingsystem) { FactoryBot.create(:operatingsystem, :with_grub, :with_associations) }
        let(:operatingsystem_id) { Foreman::GlobalId.for(operatingsystem) }
        let(:ptable_id) { Foreman::GlobalId.for(operatingsystem.ptables.first) }
        let(:medium_id) { Foreman::GlobalId.for(operatingsystem.media.first) }
        let(:architecture_id) { Foreman::GlobalId.for(operatingsystem.architectures.first) }
        let(:ip) { '192.0.2.1' }

        let(:environment) { FactoryBot.create(:environment, locations: [tax_location], organizations: [organization]) }
        let(:environment_id) { Foreman::GlobalId.for(environment) }
        let(:puppetclass) { FactoryBot.create(:puppetclass) }
        let(:puppetclass_id) { Foreman::GlobalId.for(puppetclass) }

        let(:variables) do
          {
            name: hostname,
            environmentId: environment_id,
            ip: ip,
            locationId: location_id,
            organizationId: organization_id,
            domainId: domain_id,
            operatingsystemId: operatingsystem_id,
            ptableId: ptable_id,
            mediumId: medium_id,
            architectureId: architecture_id,
            puppetclassIds: [puppetclass_id],
            interfacesAttributes: [
              {
                type: 'bond',
                attachedTo: %w[eth0 eth1],
                identifier: 'bond0',
                primary: true,
                provision: true,
                managed: true,
              },
            ],
          }
        end
        let(:context_user) { FactoryBot.create(:user, :admin, locations: [tax_location], organizations: [organization]) }
        let(:data) { result['data']['createHost']['host'] }

        let(:query) do
          <<-GRAPHQL
            mutation createHostMutation(
                $name: String!,
                $environmentId: ID,
                $ip: String,
                $locationId: ID!,
                $organizationId: ID!,
                $domainId: ID,
                $operatingsystemId: ID,
                $architectureId: ID,
                $ptableId: ID,
                $mediumId: ID,
                $puppetclassIds: [ID!],
                $interfacesAttributes: [InterfaceAttributesInput!]
              ) {
              createHost(input: {
                name: $name,
                environmentId: $environmentId,
                ip: $ip,
                architectureId: $architectureId,
                locationId: $locationId,
                organizationId: $organizationId,
                domainId: $domainId,
                operatingsystemId: $operatingsystemId,
                ptableId: $ptableId,
                mediumId: $mediumId,
                puppetclassIds: $puppetclassIds,
                interfacesAttributes: $interfacesAttributes,
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

            assert_equal 1, host.interfaces.count
            interface = host.interfaces.first
            assert_equal 'Nic::Bond', interface.type
            assert_same_elements %w[eth0 eth1], JSON.parse(interface.attached_to)
            assert_equal 'bond0', interface.identifier
            assert interface.primary
            assert interface.provision
            assert interface.managed

            assert_not_nil host.pxe_loader

            assert_not_nil data
          end
        end
      end
    end
  end
end
