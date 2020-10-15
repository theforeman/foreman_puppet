module ForemanPuppetEnc
  module Extensions
    module Taxonomy
      extend ActiveSupport::Concern

      included do
        has_many :environments, through: :taxable_taxonomies, source: :taxable, source_type: 'ForemanPuppetEnc::Environment'

        has_many :puppetclasses, through: :environments
      end

      def dup
        new = super
        new.environments = environments
        new
      end
    end
  end
end
