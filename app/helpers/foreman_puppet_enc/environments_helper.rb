module ForemanPuppetEnc
  module EnvironmentsHelper
    include PuppetclassesAndEnvironmentsHelper

    def url_for(*args)
      super
    rescue ActionController::UrlGenerationError => _e
      foreman_puppet_enc.url_for(*args)
    end

    def environments_title_actions
      title_actions import_proxy_select(hash_for_import_environments_environments_path),
        button_group(new_link(_('Create Puppet Environment'), engine: foreman_puppet_enc)),
        button_group(help_button)
    end
  end
end
