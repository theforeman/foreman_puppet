class MigratePuppetCoreTypes < ActiveRecord::Migration[6.0]
  def up
    %w[PuppetclassLookupKey Puppetclass Environment ConfigGroup].each do |type|
      Audit.where(auditable_type: type).update_all(auditable_type: "ForemanPuppet::#{type}")
      Permission.where(resource_type: type).update_all(resource_type: "ForemanPuppet::#{type}")
    end
    LookupKey.where(type: 'PuppetclassLookupKey').update_all(type: 'ForemanPuppet::PuppetclassLookupKey')
    TaxableTaxonomy.where(taxable_type: 'Environment').update_all(taxable_type: 'ForemanPuppet::Environment')
  end

  def down
    %w[PuppetclassLookupKey Puppetclass Environment ConfigGroup].each do |type|
      Audit.where(auditable_type: "ForemanPuppet::#{type}").update_all(auditable_type: type)
      Permission.where(resource_type: "ForemanPuppet::#{type}").update_all(resource_type: type)
    end
    LookupKey.where(type: 'ForemanPuppet::PuppetclassLookupKey').update_all(type: 'PuppetclassLookupKey')
    TaxableTaxonomy.where(taxable_type: 'ForemanPuppet::Environment').update_all(taxable_type: 'Environment')
  end
end
