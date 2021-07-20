# frozen_string_literal: true

module ForemanPuppet
  module Types
    module InterfaceAttributesInputExtensions
      delegate :with_indifferent_access, to: :to_h
    end
  end
end
