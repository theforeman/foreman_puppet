module ForemanPuppet
  class PuppetSmartProxiesController < ApplicationController
    before_action :find_resource
    before_action :find_status, only: [:environments]

    def environments
      render partial: 'foreman_puppet/puppet_smart_proxies/environments', locals: { environments: @proxy_status[:puppet].environment_stats }
    rescue Foreman::Exception => e
      process_ajax_error e
    end

    def dashboard
      @data = Dashboard::Data.new("puppet_proxy_id = \"#{@smart_proxy.id}\"")
      render partial: 'foreman_puppet/puppet_smart_proxies/dashboard'
    rescue Foreman::Exception => e
      process_ajax_error e
    end

    private

    def find_status
      @proxy_status = @smart_proxy.statuses
    end

    def action_permission
      case params[:action]
      when 'environments', 'dashboard'
        :view
      else
        super
      end
    end

    def resource_name(resource = controller_name)
      resource = 'smart_proxies' if resource == 'puppet_smart_proxies'
      super(resource)
    end
  end
end
