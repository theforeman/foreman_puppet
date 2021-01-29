module ForemanPuppetEnc
  module Extensions
    module ApiHostgroupsController
      extend ActiveSupport::Concern

      included do
        prepend PatchMethods

        if ForemanPuppetEnc.extracted_from_core?
          method_desc = Apipie.get_method_description(self, :index)
          method_desc.apis << Apipie::MethodDescription::Api.new(:GET, '/puppetclasses/:puppetclass_id/hostgroups', N_('List all host groups for a Puppet class'), {})

          apipie_update_methods([:index]) do
            param :puppetclass_id, String, desc: N_('ID of Puppetclass')
          end

          apipie_update_methods(%i[create update]) do
            param :hostgroup, Hash do
              param :environment_id, String, desc: N_('Deprecated in favor of hostgroup/puppet_attributes/environment_id')
              param :puppetclass_ids, Array, desc: N_('Deprecated in favor of hostgroup/puppet_attributes/puppetclass_ids')
              param :config_group_ids, Array, desc: N_('Deprecated in favor of hostgroup/puppet_attributes/config_group_ids')

              param :puppet_attributes, Hash do
                param :environment_id, String, desc: N_('ID of associated puppet Environment')
                param :puppetclass_ids, Array, desc: N_('IDs of associated Puppetclasses')
                param :config_group_ids, Array, desc: N_('IDs of associated ConfigGroups')
              end
            end
          end
        end
      end

      module PatchMethods
        def allowed_nested_id
          super | ['puppetclass_id']
        end
      end
    end
  end
end
