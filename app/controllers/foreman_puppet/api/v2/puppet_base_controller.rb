module ForemanPuppet
  module Api
    module V2
      class PuppetBaseController < ::Api::V2::BaseController
        resource_description do
          api_version 'v2'
        end

        before_action :show_deprecation_for_core_routes

        protected

        def show_deprecation_for_core_routes
          return if request.path.starts_with?('/foreman_puppet') || request.path.starts_with?('/api/smart_proxies')
          Foreman::Deprecation.api_deprecation_warning(
            format(
              '/api/v2/%{controller} API endpoints are deprecated, please use /foreman_puppet/api/v2/%{controller} instead',
              controller: controller_name
            )
          )
        end
      end
    end
  end
end
