object @facet

attributes :environment_id, :environment_name

ForemanPuppet::HostgroupPuppetFacet.nested_attribute_fields.each do |nested_field|
  node(:"inherited_#{nested_field}") { |puppet_facet| puppet_facet.nested(nested_field) if puppet_facet[nested_field].nil? }
end
