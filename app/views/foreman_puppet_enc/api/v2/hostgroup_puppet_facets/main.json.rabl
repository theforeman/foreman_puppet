attributes :environment_id, :environment_name

child root_object.puppet.config_groups => :config_groups do
  extends 'foreman_puppet_enc/api/v2/config_groups/main'
end
