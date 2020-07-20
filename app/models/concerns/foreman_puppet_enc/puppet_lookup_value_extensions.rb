module ForemanPuppetEnc
  module PuppetLookupValueExtensions
    extend ActiveSupport::Concern

    included do
      validate :value_present?, if: ->(v) { v.lookup_key.is_a?(ForemanPuppetEnc::PuppetclassLookupKey) }
    end

    def value_present?
      errors.add(:value, :blank) if value.to_s.empty? && !omit
    end
  end
end
