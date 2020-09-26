class CreateHostPuppetFacet < ActiveRecord::Migration[6.0]
  def change
    create_table :host_puppet_facets do |t|
      t.references :host, foreign_key: true
      t.references :environment, foreign_key: true
      t.references :puppet_proxy, foreign_key: { to_table: :smart_proxies }
      t.timestamps null: true
    end
  end
end
