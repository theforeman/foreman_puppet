class AddPuppetCaProxyColumn < ActiveRecord::Migration[6.0]
  def change
    change_table :host_puppet_facets do |t|
      t.references :puppet_ca_proxy, foreign_key: { to_table: :smart_proxies }
    end
    change_table :hostgroup_puppet_facets do |t|
      t.references :puppet_ca_proxy, foreign_key: { to_table: :smart_proxies }
    end
  end
end
