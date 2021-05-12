module ForemanPuppet
  module Types
    class Puppetclass < ::Types::BaseObject
      model_class ForemanPuppet::Puppetclass
      description 'A Puppetclass'

      global_id_field :id
      timestamps
      field :name, String

      has_many :environments, ForemanPuppet::Types::Environment
      has_many :locations, ::Types::Location
      has_many :organizations, ::Types::Organization

      def self.graphql_definition
        super.tap { |type| type.instance_variable_set(:@name, 'ForemanPuppet::Puppetclass') }
      end
    end
  end
end
