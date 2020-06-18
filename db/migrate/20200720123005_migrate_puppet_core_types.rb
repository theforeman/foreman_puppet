class MigratePuppetCoreTypes < ActiveRecord::Migration[6.0]
  def up
    Audit.where(auditable_type: 'PuppetclassLookupKey').update_all(auditable_type: 'ForemanPuppetEnc::PuppetclassLookupKey')
  end

  def down
    Audit.where(auditable_type: 'ForemanPuppetEnc::PuppetclassLookupKey').update_all(auditable_type: 'PuppetclassLookupKey')
  end
end
