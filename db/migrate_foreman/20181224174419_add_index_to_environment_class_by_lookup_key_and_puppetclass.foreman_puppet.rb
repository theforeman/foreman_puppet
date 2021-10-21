# Added in theforeman/foreman#6d9e2b7c61
class AddIndexToEnvironmentClassByLookupKeyAndPuppetclass < ActiveRecord::Migration[5.2]
  def change
    add_index :environment_classes, %i[puppetclass_lookup_key_id puppetclass_id], name: 'index_env_classes_on_lookup_key_and_class'
  end
end
