class CreateHostgroupsPuppetclasses < ActiveRecord::Migration[6.0]
  def up
    create_table :hostgroups_puppetclasses, id: false, if_not_exists: true do |t|
      t.references :hostgroup, null: false
      t.references :puppetclass, null: false
    end
  end

  def down
    drop_table :hostgroups_puppetclasses
  end
end
