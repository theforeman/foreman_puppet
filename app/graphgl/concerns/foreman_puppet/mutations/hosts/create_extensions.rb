# frozen_string_literal: true

module ForemanPuppet
  module Mutations
    module Hosts
      module CreateExtensions
        PUPPET_PARAMS = %i[
          environment
          puppetclasses
        ].freeze

        extend ActiveSupport::Concern

        included do
          argument :environment_id, GraphQL::Types::ID, loads: ForemanPuppet::Types::Environment
          argument :puppetclass_ids, [GraphQL::Types::ID], loads: ForemanPuppet::Types::Puppetclass, as: :puppetclasses

          private

          def initialize_object(params)
            host = super(params.except(*PUPPET_PARAMS))
            host.build_puppet(params.slice(*PUPPET_PARAMS))
            host
          end
        end
      end
    end
  end
end
