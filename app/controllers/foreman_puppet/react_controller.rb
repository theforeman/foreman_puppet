module ForemanPuppet
  class ReactController < ::ApplicationController
    layout 'foreman_puppet/layouts/application_react'

    def index
      render html: nil, layout: true
    end

    private

    def controller_permission
      :foreman_puppet
    end

    def action_permission
      :view
    end
  end
end
