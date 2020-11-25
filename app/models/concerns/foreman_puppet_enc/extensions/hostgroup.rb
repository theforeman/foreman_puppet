module ForemanPuppetEnc
  module Extensions
    module Hostgroup
      extend ActiveSupport::Concern

      included do
        if ForemanPuppetEnc.extracted_from_core?
          # has_one :environment, through: :puppet
        else
          # self.clear_reflections_cache
          # self._reflections = self._reflections.except('hostgroup_classes', 'puppetclasses')
          env_assoc = reflect_on_association(:environment)
          env_assoc.instance_variable_set(:@class_name, 'ForemanPuppetEnc::Environment')
        end

        include_in_clone puppet: :hostgroup_classes
      end
    end
  end
end
