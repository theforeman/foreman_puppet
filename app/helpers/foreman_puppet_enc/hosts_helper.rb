module ForemanPuppetEnc
  module HostsHelper
    UI.register_host_description do
      multiple_actions_provider :puppet_host_multiple_actions
    end

    def puppet_host_multiple_actions
      if ForemanPuppetEnc.extracted_from_core?
        actions = [{ action: [_('Change Environment'), foreman_puppet_enc.select_multiple_environment_hosts_path], priority: 200 }]
        if authorized_for(controller: :hosts, action: :edit)
          if SmartProxy.unscoped.authorized.with_features('Puppet').exists?
            actions << { action: [_('Change Puppet Master'), foreman_puppet_enc.select_multiple_puppet_proxy_hosts_path], priority: 1050 }
          end
        end
        actions
      else
        []
      end
    end
  end
end
