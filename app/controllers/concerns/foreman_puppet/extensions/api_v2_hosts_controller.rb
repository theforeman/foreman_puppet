module ForemanPuppet
  module Extensions
    module ApiV2HostsController
      extend ActiveSupport::Concern

      included do
        prepend PatchMethods

        method_desc = Apipie.get_method_description(self, :index)
        method_desc.apis << Apipie::MethodDescription::Api.new(:GET, '/environments/:environment_id/hosts', N_('List hosts per environment'), {})

        apipie_update_methods([:index]) do
          param :environment_id, String, desc: N_('ID of puppet environment')
        end

        apipie_update_methods(%i[create update]) do
          param :host, Hash do
            param :environment_id, String, desc: N_('Deprecated in favor of host/puppet_attributes/environment_id')
            param :puppetclass_ids, Array, desc: N_('Deprecated in favor of host/puppet_attributes/puppetclass_ids')
            param :config_group_ids, Array, desc: N_('Deprecated in favor of host/puppet_attributes/config_group_ids')

            param :puppet_attributes, Hash do
              param :environment_id, String, desc: N_('ID of associated puppet Environment')
              param :puppetclass_ids, Array, desc: N_('IDs of associated Puppetclasses')
              param :config_group_ids, Array, desc: N_('IDs of associated ConfigGroups')
            end
          end
        end
      end

      module PatchMethods
        def resource_name(*attrs)
          return 'foreman_puppet/environment' if attrs.first.is_a?(String) &&
                                                 attrs.first.start_with?('environment')
          super(*attrs)
        end

        def allowed_nested_id
          ids = super
          ids << 'environment_id'
          ids.uniq
        end
      end
    end
  end
end
