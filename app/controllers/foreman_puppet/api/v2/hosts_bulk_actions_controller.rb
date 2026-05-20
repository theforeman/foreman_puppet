module ForemanPuppet
  module Api
    module V2
      class HostsBulkActionsController < ::ForemanPuppet::Api::V2::PuppetBaseController
        include ::Api::V2::BulkHostsExtension
        before_action :find_editable_hosts, only: %i[change_environment change_puppet_proxy remove_puppet_proxy]
        before_action :find_environment, only: %i[change_environment]
        before_action :validate_environment_taxonomies, only: %i[change_environment]
        before_action :find_smart_proxy, only: %i[change_puppet_proxy]

        def_param_group :bulk_params do
          param :organization_id, :number, required: true, desc: N_('ID of the organization')
          param :included, Hash, required: true, action_aware: true do
            param :search, String, required: false, desc: N_('Search string for hosts to perform an action on')
            param :ids, Array, required: false, desc: N_('List of host ids to perform an action on')
          end
          param :excluded, Hash, required: true, action_aware: true do
            param :ids, Array, required: false, desc: N_('List of host ids to exclude and not run an action on')
          end
        end

        api :PUT, '/foreman_puppet/api/v2/hosts/bulk/change_environment', N_('Change Puppet environment')
        param_group :bulk_params
        param :environment_id, String, required: false, desc: N_('ID of the Puppet environment to set for the selected hosts')
        def change_environment
          error_hosts = ::BulkHostsManager.new(hosts: @hosts).change_puppet_environment(resolved_environment)

          process_bulk_response(
            error_hosts,
            success_message: format(n_(
              'Updated host: changed environment',
              'Updated hosts: changed environment',
              @hosts.count
            )),
            error_message: format(n_(
              'Failed to change environment for %{count} host',
              'Failed to change environment for %{count} hosts',
              error_hosts.count
            ), count: error_hosts.count)
          )
        end

        api :PUT, '/hosts/bulk/change_puppet_proxy', N_('Change Puppet (CA) Proxy')
        param_group :bulk_params
        param :proxy_id, :number, required: true, desc: N_('ID of the Puppet proxy to reassign the hosts to')
        param :ca_proxy, :bool, required: true, desc: N_('True, if Puppet CA proxy should be changed instead of the Puppet proxy')
        def change_puppet_proxy
          error_hosts = ::BulkHostsManager.new(hosts: @hosts).change_puppet_proxy(@proxy, ca_proxy?)
          process_bulk_puppet_proxy_response(
            error_hosts,
            success_message: format(n_(
              'Updated host: changed %{proxy_type}',
              'Updated hosts: changed %{proxy_type}',
              @hosts.count
            ), proxy_type: proxy_type),
            error_message: format(n_(
              'Failed to change %{proxy_type} for %{count} host',
              'Failed to change %{proxy_type} for %{count} hosts',
              error_hosts.count
            ), proxy_type: proxy_type, count: error_hosts.count)
          )
        end

        api :PUT, '/hosts/bulk/remove_puppet_proxy', N_('Remove Puppet (CA) Proxy')
        param_group :bulk_params
        param :ca_proxy, :bool, required: true, desc: N_('True, if Puppet CA proxy should be removed instead of the Puppet proxy')
        def remove_puppet_proxy
          error_hosts = ::BulkHostsManager.new(hosts: @hosts).change_puppet_proxy(nil, ca_proxy?)
          process_bulk_puppet_proxy_response(
            error_hosts,
            success_message: format(n_(
              'Updated host: removed %{proxy_type}',
              'Updated hosts: removed %{proxy_type}',
              @hosts.count
            ), proxy_type: proxy_type),
            error_message: format(n_(
              'Failed to remove %{proxy_type} for %{count} host',
              'Failed to remove %{proxy_type} for %{count} hosts',
              error_hosts.count
            ), proxy_type: proxy_type, count: error_hosts.count)
          )
        end

        private

        def find_editable_hosts
          find_bulk_hosts(:edit_hosts, params)
        end

        def process_bulk_puppet_proxy_response(error_hosts, success_message:, error_message:)
          process_bulk_response(
            error_hosts,
            success_message: success_message,
            error_message: error_message
          )
        end

        def process_bulk_response(error_hosts, success_message:, error_message:)
          if error_hosts.empty?
            process_response(true, { message: success_message })
          else
            render_error(:bulk_hosts_error, status: :unprocessable_entity,
              locals: { message: error_message, failed_host_ids: error_hosts })
          end
        end

        def find_smart_proxy
          feature = ca_proxy? ? 'Puppet CA' : 'Puppet'
          @proxy = SmartProxy.with_features(feature).find_by(id: params[:proxy_id])

          if @proxy.nil?
            render json: {
              error: {
                message: format(_('A Smart Proxy with id %{id} and the %{proxy_type} feature could not be found.'), id: params[:proxy_id], proxy_type: proxy_type),
              },
            }, status: :unprocessable_entity
            false
          else
            true
          end
        end

        def ca_proxy?
          Foreman::Cast.to_bool(params[:ca_proxy])
        end

        def find_environment
          return true if environment_value == 'inherit' || environment_value.blank?

          @environment = ForemanPuppet::Environment.find_by(id: environment_value)
          return true if @environment.present?

          render json: {
            error: {
              message: format(_('A Puppet environment with id %{id} could not be found.'), id: environment_value),
            },
          }, status: :unprocessable_entity
          false
        end

        def validate_environment_taxonomies
          return true if resolved_environment.blank? || resolved_environment == 'inherit'

          invalid_host_ids = @hosts.reject do |host|
            ForemanPuppet::Environment.with_taxonomy_scope(host.organization, host.location)
                                      .exists?(id: resolved_environment.id)
          end.map(&:id)

          return true if invalid_host_ids.empty?

          render_error(:bulk_hosts_error, status: :unprocessable_entity,
            locals: {
              message: _('Selected Puppet environment is not assigned to the proper organization and/or location for all hosts.'),
              failed_host_ids: invalid_host_ids,
            })
          false
        end

        def environment_value
          params[:environment_id]
        end

        def resolved_environment
          return 'inherit' if environment_value == 'inherit'
          return nil if environment_value.blank?

          @environment
        end

        def proxy_type
          ca_proxy? ? _('Puppet CA proxy') : _('Puppet proxy')
        end
      end
    end
  end
end
