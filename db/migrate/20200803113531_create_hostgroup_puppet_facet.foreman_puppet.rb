class CreateHostgroupPuppetFacet < ActiveRecord::Migration[6.0]
  def change
    create_table :hostgroup_puppet_facets do |t|
      t.references :hostgroup, foreign_key: true
      t.references :environment, foreign_key: true
      t.references :puppet_proxy, foreign_key: { to_table: :smart_proxies }
      t.timestamps null: true
    end
  end
end
