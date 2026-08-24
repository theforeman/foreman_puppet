module ForemanPuppet
  module Extensions
    module ApiHostgroupsController
      extend ActiveSupport::Concern

      included do
        apipie_update_methods(%i[create update]) do
          param :hostgroup, Hash do
            param :puppet_attributes, Hash do
              param :environment_id, String, desc: N_('ID of associated puppet Environment')
              param :puppetclass_ids, Array, desc: N_('IDs of associated Puppetclasses')
              param :config_group_ids, Array, desc: N_('IDs of associated ConfigGroups')
            end
          end
        end
      end
    end
  end
end
