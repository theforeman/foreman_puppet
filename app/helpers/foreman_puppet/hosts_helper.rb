module ForemanPuppet
  module HostsHelper
    UI.register_host_description do
      multiple_actions_provider :puppet_host_multiple_actions
      # otherwise registered twice
      overview_buttons_provider :puppet_host_overview_buttons if ForemanPuppet.extracted_from_core?
    end

    def puppet_host_multiple_actions
      if ForemanPuppet.extracted_from_core?
        actions = [{ action: [_('Change Environment'), foreman_puppet.select_multiple_environment_hosts_path], priority: 200 }]
        if authorized_for(controller: :hosts, action: :edit) && SmartProxy.unscoped.authorized.with_features('Puppet').exists?
          actions << { action: [_('Change Puppet Master'), foreman_puppet.select_multiple_puppet_proxy_hosts_path], priority: 1050 }
        end
        actions
      else
        []
      end
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
  end
end
