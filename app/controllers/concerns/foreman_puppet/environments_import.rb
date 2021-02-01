# various methods which gets added to the puppetclasses and environments controllers

module ForemanPuppet
  module EnvironmentsImport
    extend ActiveSupport::Concern

    included do
      before_action :importer, only: :import_environments
    end

    def import_environments
      @changed = importer.changes

      if @importer.ignored_boolean_environment_names?
        warning(_('Ignored environment names resulting in booleans found. Please quote strings like true/false and yes/no in config/ignored_environments.yml'))
      end

      if !@changed['new'].empty? || !@changed['obsolete'].empty? || !@changed['updated'].empty?
        render 'common/_puppetclasses_or_envs_changed'
      else
        info_message = _('No changes to your environments detected')

        list_ignored(info_message, @changed['ignored']) if @changed['ignored'].present?

        info info_message
        redirect_to controller: controller_path
      end
    end

    def obsolete_and_new
      if (errors = PuppetClassImporter.new.obsolete_and_new(params[:changed])).empty?
        success _('Successfully updated environments and Puppet classes from the on-disk Puppet installation')
      else
        error _('Failed to update environments and Puppet classes from the on-disk Puppet installation: %s') % errors.to_sentence
      end
      redirect_to controller: controller_path
    end

    private

    def importer
      opts = params[:proxy].blank? ? {} : { url: SmartProxy.find(params[:proxy]).try(:url) }
      opts[:env] = params[:env] if params[:env].present?
      @importer = PuppetClassImporter.new(opts)
    rescue ::Foreman::Exception => _e
      error _("No smart proxy was found to import environments from, ensure that at least one smart proxy is registered with the 'puppet' feature")
      redirect_to controller: controller_path
    end

    def list_ignored(info_message, ignored)
      environments = ignored.select { |_, values| values.first == '_ignored_' }
      ignore_info = if environments.any?
                      _('Ignored environments: %s') % environments.keys.to_sentence
                    else
                      _('Ignored classes in the environments: %s') % ignored.keys.to_sentence
                    end

      info_message << "\n" << ignore_info
    end
  end
end
