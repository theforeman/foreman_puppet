module ForemanPuppetEnc
  # Example: Plugin's HostsController inherits from Foreman's HostsController
  class HostsController < ::HostsController
    # change layout if needed
    # layout 'foreman_puppet_enc/layouts/new_layout'

    def new_action
      # automatically renders view/foreman_puppet_enc/hosts/new_action
    end
  end
end
