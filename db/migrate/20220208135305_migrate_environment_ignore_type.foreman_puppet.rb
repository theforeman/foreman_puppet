class MigrateEnvironmentIgnoreType < ActiveRecord::Migration[6.0]
  def up
    taxonomies = Taxonomy.unscoped.where("ignore_types LIKE '%Environment%'")
    environment_ids = ForemanPuppet::Environment.unscoped.pluck(:id)

    taxonomies.each do |tax|
      new_types = tax.ignore_types.reject { |type| type == 'Environment' }
      tax.update_columns(ignore_types: new_types)
      taxable_rows = environment_ids.map do |env_id|
        { taxable_id: env_id, taxable_type: 'ForemanPuppet::Environment', taxonomy_id: tax.id }
      end
      TaxableTaxonomy.insert_all(taxable_rows) if taxable_rows.any?
    end
  end
end
