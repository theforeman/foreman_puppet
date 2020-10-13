class CreateEnvironmentClasses < ActiveRecord::Migration[5.0]
  class EnvironmentClass < ApplicationRecord; end

  def up
    rename_table :environments_puppetclasses, :environment_classes
    add_column :environment_classes, :puppetclass_lookup_key_id, :integer
    add_foreign_key :environment_classes, :lookup_keys, column: :puppetclass_lookup_key_id, name: 'environment_classes_lookup_key_id_fk'
  end

  def down
    remove_foreign_key :environment_classes, :lookup_key
    drop_column :environment_classes, :puppetclass_lookup_key_id, :integer
    rename_table :environment_classes, :environments_puppetclasses
  end
end
