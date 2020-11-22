module ForemanPuppetEnc
  module Extensions
    module Hostgroup
      extend ActiveSupport::Concern

      included do
        env_assoc = reflect_on_association(:environment)
        env_assoc.instance_variable_set(:@class_name, 'ForemanPuppetEnc::Environment')

        include_in_clone puppet: %i[config_groups host_config_groups hostgroup_classes]
      end
    end
  end
end
