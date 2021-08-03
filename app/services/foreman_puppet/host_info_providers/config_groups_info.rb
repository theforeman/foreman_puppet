module ForemanPuppet
  module HostInfoProviders
    class ConfigGroupsInfo < HostInfo::Provider
      def host_info
        return {} unless host.puppet

        config_groups = (host.puppet.config_groups + host.puppet.parent_config_groups).uniq.map(&:name)
        { 'parameters' => { 'foreman_config_groups' => config_groups } }
      end
    end
  end
end
