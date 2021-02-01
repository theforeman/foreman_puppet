module ForemanPuppet
  module Parameters
    module Environment
      extend ActiveSupport::Concern
      include Foreman::Controller::Parameters::Taxonomix

      class_methods do
        def environment_params_filter
          Foreman::ParameterFilter.new(ForemanPuppet::Environment).tap do |filter|
            filter.permit :name
            add_taxonomix_params_filter(filter)
          end
        end
      end

      def environment_params
        self.class.environment_params_filter.filter_params(params, parameter_filter_context)
      end
    end
  end
end
