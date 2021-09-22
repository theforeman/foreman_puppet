class AddSomeIndexes < ActiveRecord::Migration[4.2]
  def change
    # puppetclasses
    add_index :puppetclasses, :name
    # hostgroups_puppetclasses
    add_index :hostgroups_puppetclasses, :puppetclass_id
    add_index :hostgroups_puppetclasses, :hostgroup_id

    # turn off Foreign Key checks
    execute 'SET CONSTRAINTS ALL DEFERRED;' if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'

    add_foreign_key 'host_classes', 'hosts', name: 'host_classes_host_id_fk'
    add_foreign_key 'host_classes', 'puppetclasses', name: 'host_classes_puppetclass_id_fk'
    add_foreign_key 'hostgroup_classes', 'hostgroups', name: 'hostgroup_classes_hostgroup_id_fk'
    add_foreign_key 'hostgroup_classes', 'puppetclasses', name: 'hostgroup_classes_puppetclass_id_fk'
    add_foreign_key 'operatingsystems_puppetclasses', 'operatingsystems', name: 'operatingsystems_puppetclasses_operatingsystem_id_fk'
    add_foreign_key 'operatingsystems_puppetclasses', 'puppetclasses', name: 'operatingsystems_puppetclasses_puppetclass_id_fk'
  end
end
