object @environment

extends 'foreman_puppet/api/v2/environments/main'

child :template_combinations do
  extends 'api/v2/template_combinations/base'
end

child :puppetclasses do
  extends 'foreman_puppet/api/v2/puppetclasses/base'
end

node do |environment|
  partial('api/v2/taxonomies/children_nodes', object: environment)
end
