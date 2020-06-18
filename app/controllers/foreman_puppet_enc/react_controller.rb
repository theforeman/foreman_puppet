module ForemanPuppetEnc
  class ReactController < ::ApplicationController
    layout 'foreman_puppet_enc/layouts/application_react'

    def index
      render html: nil, layout: true
    end

    private

    def controller_permission
      :foreman_puppet_enc
    end

    def action_permission
      :view
    end
  end
end
