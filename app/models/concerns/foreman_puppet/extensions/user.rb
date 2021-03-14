module ForemanPuppet
  module Extensions
    module User
      extend ActiveSupport::Concern

      included do
        prepend PatchedMethods
      end

      module PatchedMethods
        def visible_environments
          authorized_scope = ForemanPuppet::Environment.unscoped.authorized(:view_environments)
          authorized_scope = authorized_scope
                             .joins(:taxable_taxonomies)
                             .where('taxable_taxonomies.taxonomy_id' => taxonomy_ids[:organizations] + taxonomy_ids[:locations])
          result = authorized_scope.distinct.pluck(:name)
          if ::User.current.admin?
            # Admin users can also see Environments that do not have any organization or location, even when
            # organizations and locations are enabled.
            untaxed_env_ids = TaxableTaxonomy.where(taxable_type: 'ForemanPuppet::Environment').distinct.select(:taxable_id)
            untaxed_environments = ForemanPuppet::Environment.unscoped.where.not(id: untaxed_env_ids).pluck(:name)
            result += untaxed_environments
          end
          result
        end
      end
    end
  end
end
