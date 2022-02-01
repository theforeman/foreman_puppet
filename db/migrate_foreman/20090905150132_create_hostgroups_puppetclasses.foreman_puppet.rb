class CreateHostgroupsPuppetclasses < ActiveRecord::Migration[6.0]
  def up
    # this table is later renamed into hostgroup_classes and thus we don't want to create it if it exists under the later name
    return if table_exists?(:hostgroups_puppetclasses) || table_exists?(:hostgroup_classes)
    create_table :hostgroups_puppetclasses, id: false do |t|
      t.references :hostgroup, foreign_key: true, null: false
      t.references :puppetclass, foreign_key: true, null: false
    end
  end

  def down
    drop_table :hostgroups_puppetclasses
  end
end
