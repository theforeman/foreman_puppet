module ForemanPuppetEnc
  # Example: Plugin's HostsController inherits from Foreman's HostsController
  class HostsController < ::Api::V2::HostsController
    # change layout if needed
    # layout 'foreman_puppet_enc/layouts/new_layout'

    def new_action
      # automatically renders views/foreman_puppet_enc/api/v2/hosts/new_action
    end
  end
end
