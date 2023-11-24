module ForemanPuppet
  module HostsHelper
    UI.register_host_description do
      multiple_actions_provider :puppet_host_multiple_actions
      # otherwise registered twice
      overview_buttons_provider :puppet_host_overview_buttons
      overview_fields_provider :puppet_host_overview_fields
    end

    def puppet_host_multiple_actions
      actions = [{ action: [_('Change Environment'), foreman_puppet.select_multiple_environment_hosts_path], priority: 200 }]

      if authorized_for(controller: :hosts, action: :edit) && SmartProxy.unscoped.authorized.with_features('Puppet').exists?
        actions << { action: [_('Change Puppet Master'), foreman_puppet.select_multiple_puppet_proxy_hosts_path], priority: 1050 }
      end

      if authorized_for(controller: :hosts,
        action: :edit) && SmartProxy.unscoped.authorized.with_features('Puppet CA').exists?
        actions << { action: [_('Change Puppet CA'), select_multiple_puppet_ca_proxy_hosts_path],
priority: 1051 }
      end

      actions
    end

    def puppet_host_overview_buttons(host)
      buttons = []
      if SmartProxy.with_features('Puppet').any?
        buttons << {
          button: link_to(_('Puppet YAML'), foreman_puppet.externalNodes_host_path(name: host), title: _('Puppet external nodes YAML dump'),
                                                                                                class: 'btn btn-default'), priority: 400
        }
      end
      buttons
    end

    def puppet_host_overview_fields(host)
      fields = []
      if host.environment.present?
        fields << {
          field: [
            _('Puppet Environment'),
            link_to(host.puppet.environment, hosts_path(search: "environment = #{host.puppet.environment}")),
          ],
          priority: 650,
        }
      end
      fields
    end
  end
end
