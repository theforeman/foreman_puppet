module ForemanPuppetEnc
  module Types
    class Environment < BaseObject
      model_class ForemanPuppetEnc::Environment
      description 'An Environment'

      global_id_field :id
      timestamps
      field :name, String

      has_many :locations, Types::Location
      has_many :organizations, Types::Organization
      has_many :puppetclasses, Types::Puppetclass
    end
  end
end
