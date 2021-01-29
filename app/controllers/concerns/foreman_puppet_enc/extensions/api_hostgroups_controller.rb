module ForemanPuppetEnc
  module Extensions
    module ApiHostgroupsController
      extend ActiveSupport::Concern

      included do
        prepend PatchMethods

        if ForemanPuppetEnc.extracted_from_core?
          apipie_update_methods(%i[create update]) do
            param :hostgroup, Hash do
              param :environment_id, String, desc: N_('Deprecated in favor of hostgroup/puppet_attributes/environment_id')
            end
          end
        end
      end

      module PatchMethods
        def hostgroup_attributes(params, host = nil)
          environment_id = params.delete(:environment_id)
          attrs = super(params, host)
          if environment_id
            ::Foreman::Deprecation.api_deprecation_warning('hostgroup[environment_id] has been deprecated in favor of hostgroup[puppet_attributes][environment_id]')
            attrs[:puppet_attributes] ||= {}
            attrs[:puppet_attributes][:environment_id] ||= environment_id
          end
          attrs
        end
      end
    end
  end
end
