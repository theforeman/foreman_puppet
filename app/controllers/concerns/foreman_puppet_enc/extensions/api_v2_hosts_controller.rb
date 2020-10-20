module ForemanPuppetEnc
  module Extensions
    module ApiV2HostsController
      extend ActiveSupport::Concern

      included do
        prepend PatchMethods

        if ForemanPuppetEnc.extracted_from_core?
          method_desc = Apipie.get_method_description(self, :index)
          method_desc.apis << Apipie::MethodDescription::Api.new(:GET, '/environments/:environment_id/hosts', N_('List hosts per environment'), {})

          apipie_update_methods([:index]) do
            param :environment_id, String, desc: N_('ID of puppet environment')
          end

          apipie_update_methods(%i[create update]) do
            param :host, Hash do
              param :environment_id, String, desc: N_('Deprecated in favor of host/puppet_attributes/environment_id')
            end
          end
        end
      end

      module PatchMethods
        def host_attributes(params, host = nil)
          environment_id = params.delete(:environment_id)
          attrs = super(params, host)
          if environment_id
            ::Foreman::Deprecation.api_deprecation_warning('host[environment_id] has been deprecated in favor of host[puppet_attributes][environment_id]')
            attrs[:puppet_attributes] ||= {}
            attrs[:puppet_attributes][:environment_id] ||= environment_id
          end
          attrs
        end

        def resource_name(*attrs)
          return 'foreman_puppet_enc/environment' if attrs.first.is_a?(String) &&
                                                     attrs.first.start_with?('environment')
          super(*attrs)
        end

        def allowed_nested_id
          ids = super
          ids << 'environment_id' if ForemanPuppetEnc.extracted_from_core?
          ids.uniq
        end
      end
    end
  end
end
