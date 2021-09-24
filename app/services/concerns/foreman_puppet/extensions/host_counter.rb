module ForemanPuppet
  module Extensions
    module HostCounter
      extend ActiveSupport::Concern

      def counted_hosts
        case @association.to_s
        when 'environment'
          hosts_scope = ::Host::Managed.reorder('').joins(:puppet)
          hosts_scope.authorized(:view_hosts).group(HostPuppetFacet.arel_table[:environment_id]).count
        else
          super
        end
      end
    end
  end
end
