class MigratePuppetCoreTypes < ActiveRecord::Migration[6.0]
  def up
    %w[PuppetclassLookupKey Puppetclass Environment ConfigGroup].each do |type|
      Audit.where(auditable_type: type).update_all(auditable_type: "ForemanPuppet::#{type}")
      Permission.where(resource_type: type).update_all(resource_type: "ForemanPuppet::#{type}")
    end
    LookupKey.where(type: 'PuppetclassLookupKey').update_all(type: 'ForemanPuppet::PuppetclassLookupKey')
  end

  def down
    %w[PuppetclassLookupKey Puppetclass Environment ConfigGroup].each do |type|
      Audit.where(auditable_type: "ForemanPuppet::#{type}").update_all(auditable_type: type)
      Permission.where(resource_type: "ForemanPuppet::#{type}").update_all(resource_type: type)
    end
    LookupKey.where(type: 'ForemanPuppet::PuppetclassLookupKey').update_all(type: 'PuppetclassLookupKey')
  end
end
