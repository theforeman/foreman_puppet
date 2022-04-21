class DropEnvironmentFromHostAndHg < ActiveRecord::Migration[6.0]
  def up
    remove_column(:hostgroups, :environment_id) if column_exists?(:hostgroups, :environment_id)
    remove_column(:hosts, :environment_id) if column_exists?(:hosts, :environment_id)
  end

  # This is just to clean up core, we do not want to add the columns again on uninstall
end
