class CreateHostPuppetFacet < ActiveRecord::Migration[6.0]
  def change
    create_table :host_puppet_facets do |t|
      t.integer :host_id
    end
  end
end
