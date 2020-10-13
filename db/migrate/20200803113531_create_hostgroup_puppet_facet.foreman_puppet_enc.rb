class CreateHostgroupPuppetFacet < ActiveRecord::Migration[6.0]
  def change
    create_table :hostgroup_puppet_facets do |t|
      t.references :hostgroup, foreign_key: true
      t.references :environments, foreign_key: true
      t.timestamps null: true
    end
  end
end
