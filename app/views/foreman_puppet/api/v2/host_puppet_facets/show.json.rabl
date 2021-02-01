child :puppetclasses do
  extends 'foreman_puppet/api/v2/puppetclasses/base'
end

node do |puppet_facet|
  { all_puppetclasses: partial('foreman_puppet/api/v2/puppetclasses/base', object: puppet_facet.all_puppetclasses) }
end

child :config_groups do
  extends 'foreman_puppet/api/v2/config_groups/main'
end
