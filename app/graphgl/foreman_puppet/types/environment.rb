module ForemanPuppet
  module Types
    class Environment < ::Types::BaseObject
      graphql_name 'ForemanPuppet_Environment'
      model_class ForemanPuppet::Environment
      description 'An Environment'

      global_id_field :id
      timestamps
      field :name, String

      has_many :locations, ::Types::Location
      has_many :organizations, ::Types::Organization
      has_many :puppetclasses, ForemanPuppet::Types::Puppetclass
    end
  end
end
