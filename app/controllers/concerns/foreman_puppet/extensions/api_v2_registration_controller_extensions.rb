module ForemanPuppet
  module Extensions
    module ApiV2RegistrationControllerExtensions
      extend ActiveSupport::Concern

      def host_setup_extension
        if @host.hostgroup.present?
          @host.puppet_proxy_id = @host.hostgroup.puppet_proxy_id if @host.puppet_proxy_id.nil? && @host.hostgroup.puppet_proxy_id.present?
          @host.puppet_ca_proxy_id = @host.hostgroup.puppet_ca_proxy_id if @host.puppet_ca_proxy_id.nil? && @host.hostgroup.puppet_ca_proxy_id.present?

          if @host.puppet.nil? && @host.hostgroup.puppet&.environment.present?
            puppet = @host.puppet || @host.build_puppet
            puppet.environment = @host.hostgroup.puppet&.environment
          end
        end

        super
      end
    end
  end
end
