module ForemanPuppet
  module Api
    module V2
      class HostgroupClassesController < ::ForemanPuppet::Api::V2::PuppetBaseController
        resource_description do
          api_base_url '/foreman_puppet/api'
        end

        before_action :find_hostgroup, only: %i[index create destroy]

        api :GET, '/hostgroups/:hostgroup_id/puppetclass_ids/', N_('List all Puppet class IDs for host group')

        def index
          render json: { root_node_name => HostgroupClass.where(hostgroup_puppet_facet_id: @hostgroup.puppet.id).pluck('puppetclass_id') }
        end

        api :POST, '/hostgroups/:hostgroup_id/puppetclass_ids', N_('Add a Puppet class to host group')
        param :hostgroup_id, String, required: true, desc: N_('ID of host group')
        param :puppetclass_id, String, required: true, desc: N_('ID of Puppet class')

        def create
          @hostgroup_class = HostgroupClass.create!(hostgroup_puppet_facet_id: @hostgroup.puppet.id, puppetclass_id: params[:puppetclass_id].to_i)
          render json: { hostgroup_id: @hostgroup.puppet.hostgroup_id, puppetclass_id: @hostgroup_class.puppetclass_id }
        end

        api :DELETE, '/hostgroups/:hostgroup_id/puppetclass_ids/:id/', N_('Remove a Puppet class from host group')
        param :hostgroup_id, String, required: true, desc: N_('ID of host group')
        param :id, String, required: true, desc: N_('ID of Puppet class')

        def destroy
          @hostgroup_class = HostgroupClass.where(hostgroup_puppet_facet_id: @hostgroup.puppet.id, puppetclass_id: params[:id])
          process_response @hostgroup_class.destroy_all
        end

        def resource_class
          ForemanPuppet::HostgroupClass
        end

        private

        def find_hostgroup
          if params[:hostgroup_id].blank?
            not_found
            return false
          end
          @hostgroup = Hostgroup.find(params[:hostgroup_id]) if Hostgroup.respond_to?(:authorized) &&
                                                                Hostgroup.authorized('view_hostgroup', Hostgroup)
          @hostgroup.puppet || @hostgroup.create_puppet
          @hostgroup
        end
      end
    end
  end
end
