# Added in theforeman/foreman#bb07c3b1cf
class AddEnvironmentPuppetclassId < ActiveRecord::Migration[5.2]
  def change
    add_index :environment_classes, %i[environment_id puppetclass_id]
    remove_index :environment_classes, :environment_id
  end
end
