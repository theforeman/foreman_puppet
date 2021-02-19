class MigrateTaxonomyIgnoredType < ActiveRecord::Migration[6.0]
  def up
    Taxonomy.all.each do |taxonomy|
      next unless taxonomy.ignore_types.include?('Environment')
      taxonomy.ignore_types.delete('Environment')
      taxonomy.ignore_types << 'ForemanPuppet::Environment'
      taxonomy.save
    end
  end

  def down
    Taxonomy.all.each do |taxonomy|
      next unless taxonomy.ignore_types.include?('ForemanPuppet::Environment')
      taxonomy.ignore_types.delete('ForemanPuppet::Environment')
      taxonomy.ignore_types << 'Environment'
      taxonomy.save
    end
  end
end
