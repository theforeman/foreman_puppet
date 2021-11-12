class CleanupEnvironmentFromCoreTables < ActiveRecord::Migration[6.0]
  def up
    ::Hostgroup.update_all(environment_id: nil) if column_exists?(:hostgroups, :environment_id)
    Host::Managed.update_all(environment_id: nil) if column_exists?(:hosts, :environment_id)
  end

  def down
    # nothing to do
  end
end
