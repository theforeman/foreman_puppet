module ForemanPuppet
  module PuppetSmartProxiesHelper
    # For dashboard chart to work
    def hosts_path(*attrs)
      main_app.hosts_path(*attrs)
    end
  end
end
