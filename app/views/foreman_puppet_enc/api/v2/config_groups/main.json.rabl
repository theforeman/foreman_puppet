object @config_group
require 'pry'; binding.pry
extends "foreman_puppet_enc/api/v2/config_groups/base"

attributes :created_at, :updated_at

child :puppetclasses do
  extends "api/v2/puppetclasses/base"
end
