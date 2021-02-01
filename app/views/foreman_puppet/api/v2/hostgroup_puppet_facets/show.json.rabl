child :puppetclasses do
  extends 'foreman_puppet/api/v2/puppetclasses/base'
end

node do |hostgroup|
  { all_puppetclasses: partial('foreman_puppet/api/v2/puppetclasses/base', object: hostgroup.all_puppetclasses) }
end

child :config_groups do
  extends 'foreman_puppet/api/v2/config_groups/main'
end
