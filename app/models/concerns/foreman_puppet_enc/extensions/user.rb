module ForemanPuppetEnc
  module Extensions
    module User
      extend ActiveSupport::Concern

      def visible_environments
        authorized_scope = Environment.unscoped.authorized(:view_environments)
        authorized_scope = authorized_scope
                           .joins(:taxable_taxonomies)
                           .where('taxable_taxonomies.taxonomy_id' => taxonomy_ids[:organizations] + taxonomy_ids[:locations])
        result = authorized_scope.distinct.pluck(:name)
        if User.current.admin?
          # Admin users can also see Environments that do not have any organization or location, even when
          # organizations and locations are enabled.
          untaxed_environments = Environment.unscoped.where.not(id: TaxableTaxonomy.where(taxable_type: 'ForemanPuppetEnc::Environment').distinct.select(:taxable_id)).pluck(:name)
          result += untaxed_environments
        end
        result
      end
    end
  end
end
