module ForemanPuppetEnc
  module Api
    module V2
      class ConfigGroupsController < ::Api::V2::BaseController
        include ForemanPuppetEnc::Controller::Parameters::ConfigGroup
        before_action :show_deprecation_for_core_routes


        wrap_parameters ConfigGroup, :include => config_group_params_filter.accessible_attributes(parameter_filter_context)

        before_action :find_resource, :only => %i[show update destroy]


        resource_description do
          api_version 'v2'
          api_base_url '/foreman_puppet_enc/api'
        end

        api :GET, '/config_groups', N_('List of config groups')
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(ConfigGroup)

        def index
          @config_groups = resource_scope_for_index
        end

        api :GET, '/config_groups/:id/', N_('Show a config group')
        param :id, :identifier, :required => true

        def show; end

        def_param_group :config_group do
          param :config_group, Hash, :required => true, :action_aware => true do
            param :name, String, :required => true
            param :puppetclass_ids, Array
          end
        end

        api :POST, '/config_groups/', N_('Create a config group')
        param_group :config_group, :as => :create

        def create
          @config_group = ConfigGroup.new(config_group_params)
          process_response @config_group.save
        end

        api :PUT, '/config_groups/:id/', N_('Update a config group')
        param :id, String, :required => true
        param_group :config_group

        def update
          process_response @config_group.update(config_group_params)
        end

        api :DELETE, '/config_groups/:id/', N_('Delete a config group')
        param :id, String, :required => true

        def destroy
          process_response @config_group.destroy
        end


        private


        def show_deprecation_for_core_routes
          return if request.path.starts_with?('/foreman_puppet_enc')
          Foreman::Deprecation.api_deprecation_warning('/api/v2/config_groups API endpoints are deprecated, please use /foreman_puppet_enc/api/v2/config_groups instead')
        end
      end
    end
  end
end
