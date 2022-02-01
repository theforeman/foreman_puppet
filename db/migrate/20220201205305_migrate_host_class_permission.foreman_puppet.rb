class MigrateHostClassPermission < ActiveRecord::Migration[6.0]
  def up
    Permission.where(resource_type: 'HostClass').update_all(resource_type: 'ForemanPuppet::HostClass')
  end

  def down
    # no can do
  end
end
