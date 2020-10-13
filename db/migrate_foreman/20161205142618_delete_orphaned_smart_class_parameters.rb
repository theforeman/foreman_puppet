class DeleteOrphanedSmartClassParameters < ActiveRecord::Migration[4.2]
  def up
    condition = 'NOT EXISTS (SELECT 1 FROM environment_classes WHERE environment_classes.puppetclass_lookup_key_id = lookup_keys.id)'
    LookupValue.joins(:lookup_key).where(condition).where("lookup_keys.type = 'PuppetclassLookupKey'").delete_all
    PuppetclassLookupKey.where(condition).delete_all
  end

  def down
  end
end
