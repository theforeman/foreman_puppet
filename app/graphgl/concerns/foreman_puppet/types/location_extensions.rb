# frozen_string_literal: true

module ForemanPuppet
  module Types
    module LocationExtensions
      extend ActiveSupport::Concern

      included do
        has_many :environments, ForemanPuppet::Types::Environment
        has_many :puppetclasses, ForemanPuppet::Types::Puppetclass
      end
    end
  end
end
