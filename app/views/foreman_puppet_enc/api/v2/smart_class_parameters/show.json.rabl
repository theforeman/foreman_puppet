object @smart_class_parameter

extends 'foreman_puppet_enc/api/v2/smart_class_parameters/main'

if params[:puppetclass_id].blank?
  node do |smart_class_parameter|
    { puppetclass: partial('foreman_puppet_enc/api/v2/puppetclasses/base', object: smart_class_parameter.param_class) }
  end
end

if params[:environment_id].blank?
  child :environments do
    extends 'foreman_puppet_enc/api/v2/environments/base'
  end
end

node do |smart_class_parameter|
  { override_values: partial('foreman_puppet_enc/api/v2/override_values/index', object: smart_class_parameter.lookup_values) }
end
