module ForemanPuppet
  module Extensions
    module BulkHostsManager
      extend ActiveSupport::Concern

      def change_puppet_environment(environment)
        error_hosts = []
        @hosts.each do |host|
          puppet = host.puppet || host.build_puppet
          puppet.environment = if environment == 'inherit'
                                 host.hostgroup&.puppet&.environment
                               else
                                 environment
                               end
          host.save(validate: false)
        rescue StandardError => e
          message = format(_('Failed to set Puppet environment for %{host}.'), host: host)
          Foreman::Logging.exception(message, e)
          error_hosts << host.id
        end
        error_hosts
      end

      def change_puppet_proxy(proxy, is_ca_proxy)
        error_hosts = []
        @hosts.each do |host|
          if is_ca_proxy
            host.puppet_ca_proxy = proxy
          else
            host.puppet_proxy = proxy
          end
          host.save(validate: false)
        rescue StandardError => e
          message = format(_('Failed to set proxy for %{host}.'), host: host)
          Foreman::Logging.exception(message, e)
          error_hosts << host.id
        end
        error_hosts
      end
    end
  end
end
