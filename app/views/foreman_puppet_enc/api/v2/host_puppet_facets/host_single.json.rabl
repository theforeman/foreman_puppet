child puppet: :puppet do
  extends 'foreman_puppet_enc/api/v2/host_puppet_facets/show'
end

# backwards compatibility

child root_object.puppet.puppetclasses => :puppetclasses do
  extends 'foreman_puppet_enc/api/v2/puppetclasses/base'
end

node do |host|
  { all_puppetclasses: partial('foreman_puppet_enc/api/v2/puppetclasses/base', object: host.puppet.all_puppetclasses) }
end

child root_object.puppet.config_groups => :config_groups do
  extends 'foreman_puppet_enc/api/v2/config_groups/main'
end
