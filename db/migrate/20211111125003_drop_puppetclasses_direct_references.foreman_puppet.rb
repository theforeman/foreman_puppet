class DropPuppetclassesDirectReferences < ActiveRecord::Migration[6.0]
  def up
    remove_reference(:host_classes, :host, index: true, foreign_key: true)
    remove_reference(:hostgroup_classes, :hostgroup, index: true, foreign_key: true)
  end

  def down
    add_reference :host_classes, :host, foreign_key: true, index: true
    add_reference :hostgroup_classes, :hostgroup, foreign_key: true, index: true
  end
end
