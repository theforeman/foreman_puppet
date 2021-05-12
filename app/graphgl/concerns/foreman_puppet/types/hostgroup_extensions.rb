# frozen_string_literal: true

module ForemanPuppet
  module Types
    module HostgroupExtensions
      extend ActiveSupport::Concern

      included do
        belongs_to :environment, ForemanPuppet::Types::Environment
      end
    end
  end
end
