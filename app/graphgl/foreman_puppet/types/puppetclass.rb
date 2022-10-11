module ForemanPuppet
  module Types
    class Puppetclass < ::Types::BaseObject
      graphql_name 'ForemanPuppet_Puppetclass'
      model_class ForemanPuppet::Puppetclass
      description 'A Puppetclass'

      global_id_field :id
      timestamps
      field :name, String

      has_many :environments, ForemanPuppet::Types::Environment
      has_many :locations, ::Types::Location
      has_many :organizations, ::Types::Organization
    end
  end
end
