class RemoveKatelloIdFromEnvironments < ActiveRecord::Migration[6.0]
  def up
    remove_column :environments, :katello_id if column_exists?(:environments, :katello_id)
  end
end
