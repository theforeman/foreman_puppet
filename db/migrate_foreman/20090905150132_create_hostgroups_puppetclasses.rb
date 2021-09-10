class CreateHostgroupsPuppetclasses < ActiveRecord::Migration[6.0]
  def up
    create_table :hostgroups_puppetclasses, id: false, if_not_exists: true do |t|
      t.references :hostgroup, foreign_key: true, null: false
      t.references :puppetclass, foreign_key: true, null: false
    end
  end

  def down
    drop_table :hostgroups_puppetclasses
  end
end
