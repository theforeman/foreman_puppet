module ForemanPuppetEnc
  module HostsHelper
    UI.register_host_description do
      multiple_actions_provider :puppet_host_multiple_actions
    end

    def puppet_host_multiple_actions
      if ForemanPuppetEnc.extracted_from_core?
        [{ action: [_('Change Environment'), foreman_puppet_enc.select_multiple_environment_hosts_path], priority: 200 }]
      else
        []
      end
    end
  end
end
