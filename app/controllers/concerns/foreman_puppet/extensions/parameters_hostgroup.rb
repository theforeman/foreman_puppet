module ForemanPuppet
  module Extensions
    module ParametersHostgroup
      extend ActiveSupport::Concern

      included do
        class << self
          prepend PatchedClassMethods
        end

        prepend PatchedMethods
      end

      module PatchedClassMethods
        def hostgroup_params_filter
          super.tap do |filter|
            add_hostgroup_puppet_params_filter(filter)
          end
        end
      end

      module PatchedMethods
      end

      class_methods do
        def add_hostgroup_puppet_params_filter(filter)
          # TODO: bring to core - this is what facets should do, but does not
          filter.permit(puppet_attributes: {})
        end
      end
    end
  end
end
