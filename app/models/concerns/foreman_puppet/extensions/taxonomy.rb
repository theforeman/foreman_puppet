module ForemanPuppet
  module Extensions
    module Taxonomy
      extend ActiveSupport::Concern

      included do
        has_many :environments, through: :taxable_taxonomies, source: :taxable, source_type: 'ForemanPuppet::Environment'

        has_many :puppetclasses, through: :environments
      end

      def dup
        new = super
        new.environments = environments
        new
      end

      def environment_ids do
        if ignore?('ForemanPuppet::Environment')
          return ForemanPuppet::Environment.pluck(:id)
        else
          super()
        end
      end
    end
  end
end
