module ForemanPuppet
  module Types
    class Environment < ::Types::BaseObject
      model_class ForemanPuppet::Environment
      description 'An Environment'

      global_id_field :id
      timestamps
      field :name, String

      has_many :locations, ::Types::Location
      has_many :organizations, ::Types::Organization
      has_many :puppetclasses, ForemanPuppet::Types::Puppetclass

      def self.graphql_definition
        super.tap { |type| type.instance_variable_set(:@name, 'ForemanPuppet::Environment') }
      end
    end
  end
end
