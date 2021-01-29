child puppet: :puppet do
  extends 'foreman_puppet_enc/api/v2/hostgroup_puppet_facets/show'
end

# backwards compatibility
child root_object.puppet.puppetclasses => :puppetclasses do
  extends 'foreman_puppet_enc/api/v2/puppetclasses/base'
end

node do |hostgroup|
  { all_puppetclasses: partial('foreman_puppet_enc/api/v2/puppetclasses/base', object: hostgroup.puppet.all_puppetclasses) }
end

child root_object.puppet.config_groups => :config_groups do
  extends 'foreman_puppet_enc/api/v2/config_groups/main'
end
