class CreateHostPuppetFacet < ActiveRecord::Migration[6.0]
  def change
    create_table :host_puppet_facets do |t|
      t.references :host, foreign_key: true
      t.references :environments, foreign_key: true
      t.timestamps null: true
    end
  end
end
