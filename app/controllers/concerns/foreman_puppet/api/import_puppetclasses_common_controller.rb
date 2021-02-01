module ForemanPuppet
  module Api
    module ImportPuppetclassesCommonController
      extend ActiveSupport::Concern

      included do
        before_action :find_required_puppet_proxy, only: [:import_puppetclasses]
        before_action :find_environment_id, only: [:import_puppetclasses]
        before_action :find_optional_environment, only: [:import_puppetclasses]
      end

      extend Apipie::DSL::Concern

      api :POST, '/smart_proxies/:id/import_puppetclasses', N_('Import puppet classes from puppet proxy')
      api :POST, '/smart_proxies/:smart_proxy_id/environments/:id/import_puppetclasses', N_('Import puppet classes from puppet proxy for an environment')
      api :POST, '/environments/:environment_id/smart_proxies/:id/import_puppetclasses', N_('Import puppet classes from puppet proxy for an environment')
      param :id, :identifier, required: true
      param :smart_proxy_id, String, required: false
      param :environment_id, String, required: false
      param :dryrun, :bool, required: false
      param :except, String, required: false, desc: N_('Optional comma-delimited string'\
                                                       "containing either 'new', 'updated', or 'obsolete'"\
                                                       'that is used to limit the imported Puppet classes')

      def import_puppetclasses
        return unless changed_environments
        # @changed is returned from the method above changed_environments
        # Limit actions by setting @changed[kind] to empty hash {} (no action)
        # if :except parameter is passed with comma deliminator import_puppetclasses?except=new,obsolete
        if params[:except].present?
          kinds = params[:except].split(',')
          kinds.each do |kind|
            @changed[kind] = {} if PuppetClassImporter::CHANGE_KINDS.include?(kind)
          end
        end

        # DRYRUN - /import_puppetclasses?dryrun - do not run PuppetClassImporter
        rabl_template = @environment ? 'show' : 'index'
        if params.key?('dryrun') && ['false', false].exclude?(params['dryrun'])
          render("foreman_puppet/api/v#{api_version}/import_puppetclasses/#{rabl_template}", layout: 'api/layouts/import_puppetclasses_layout')
          return
        end

        # RUN PuppetClassImporter
        if (errors = PuppetClassImporter.new.obsolete_and_new(@changed)).empty?
          render("foreman_puppet/api/v#{api_version}/import_puppetclasses/#{rabl_template}", layout: 'api/layouts/import_puppetclasses_layout')
        else
          render json: {
            message: _('Failed to update the environments and Puppet classes from the on-disk puppet installation: %s') % errors.join(', '),
          }, status: :internal_server_error
        end
      end

      private

      def changed_environments
        @changed = import_changed_proxy_environments
        return false unless @changed

        # PuppetClassImporter expects [kind][env] to be in json format
        PuppetClassImporter::CHANGE_KINDS.each do |kind|
          next if (envs = @changed[kind]).empty?
          envs.keys.sort.each do |env|
            @changed[kind][env] = @changed[kind][env].to_json
          end
        end

        # @environments is used in import_puppletclasses/index.json.rabl
        environment_names = (@changed['new'].keys + @changed['obsolete'].keys +
                             @changed['updated'].keys + @changed['ignored'].keys).uniq.sort

        @environments = environment_names.map do |name|
          OpenStruct.new(name: name)
        end

        unless @environments.any?
          render_message(_('No changes to your environments detected'))
          return false
        end

        @environments.any?
      end

      def import_changed_proxy_environments
        opts = { url: @smart_proxy.url }
        opts[:env] = if @environment.present?
                       @environment.name
                     else
                       @env_id
                     end
        @importer = PuppetClassImporter.new(opts)
        changed = @importer.changes

        # check if environemnt id passed in URL is name of NEW environment in puppetmaster that doesn't exist in db
        if @environment || (changed['new'].key?(@env_id) && (@environment ||= OpenStruct.new(name: @env_id)))
          # only return :keys equal to @environment in @changed hash
          %w[new obsolete updated ignored].each do |kind|
            changed[kind].slice!(@environment.name) unless changed[kind].empty?
          end
        end
        changed
      rescue StandardError => e
        if /puppet feature/i.match?(e.message)
          msg = _('No proxy found to import classes from, ensure that the smart proxy has the Puppet feature enabled.')
        else
          Foreman::Logging.exception('Error while importing Puppet classes', e)
          msg = e.message
        end
        render_message(msg, status: :internal_server_error)
        nil
      end

      def find_required_puppet_proxy
        id = params.key?('smart_proxy_id') ? params['smart_proxy_id'] : params['id']
        @smart_proxy = SmartProxy.authorized(:view_smart_proxies).find(id)
        unless @smart_proxy && SmartProxy.with_features('Puppet').exists?(id: @smart_proxy.id)
          not_found _('No proxy found to import classes from, ensure that the smart proxy has the Puppet feature enabled.')
        end
        @smart_proxy
      end

      def find_environment_id
        @env_id = if params.key?('environment_id')
                    params['environment_id']
                  elsif params.key?('smart_proxy_id') && params['id'].present?
                    params['id']
                  end
        @env_id
      end

      def find_optional_environment
        @environment = Environment.authorized(:view_environments).find(@env_id) if @env_id
      rescue ActiveRecord::RecordNotFound => e
        Foreman::Logging.exception('Resource not found', e, level: :debug)
        nil
      end
    end
  end
end
