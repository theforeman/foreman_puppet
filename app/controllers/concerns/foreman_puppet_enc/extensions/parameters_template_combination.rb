module ForemanPuppetEnc
  module Extensions
    module ParametersTemplateCombination
      extend ActiveSupport::Concern

      included do
        class << self
          prepend PrependedClassMethods
        end
      end

      module PrependedClassMethods
        def template_combination_params_filter
          super.tap do |filter|
            filter.permit_by_context :environment_id, :environment_name, :environment, nested: true
          end
        end
      end
    end
  end
end
