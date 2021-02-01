module ForemanPuppet
  class PuppetclassesController < ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include Foreman::Controller::Parameters::Host
    include Foreman::Controller::Parameters::Hostgroup
    include ForemanPuppet::Parameters::Environment
    include ForemanPuppet::Parameters::Puppetclass

    before_action :find_resource, only: %i[edit update destroy override]
    before_action :setup_search_options, only: :index

    helper ForemanPuppet::PuppetclassLookupKeysHelper

    # TODO: extracted_from_core?
    def host_params(top_level_hash = controller_name.singularize)
      filter = self.class.host_params_filter
      filter.permit(puppet_attributes: {})
      filter.filter_params(params, parameter_filter_context, top_level_hash).tap do |normalized|
        if parameter_filter_context.ui? && normalized['compute_attributes'] && normalized['compute_attributes']['scsi_controllers']
          normalize_scsi_attributes(normalized['compute_attributes'])
        end
      end
    end

    def index
      @puppetclasses = resource_base_search_and_page
      allowed_hostgroup_ids = HostgroupPuppetFacet.joins(:hostgroup_classes)
                                                  .where(HostgroupClass.arel_table[:puppetclass_id].in(@puppetclasses.map(&:id)))
                                                  .pluck(:hostgroup_id).uniq
      @hostgroups_authorizer = Authorizer.new(User.current, collection: allowed_hostgroup_ids)
    end

    def edit
    end

    def update
      if @puppetclass.update(puppetclass_params)
        process_success
      else
        process_error
      end
    end

    def destroy
      if @puppetclass.destroy
        process_success
      else
        process_error
      end
    end

    def override
      if @puppetclass.class_params.present?
        @puppetclass.class_params.each do |class_param|
          class_param.update(override: params[:enable])
        end
        if [true, 'true'].include?(params[:enable])
          success _('Successfully overridden all parameters of Puppet class %s') % @puppetclass.name
        else
          success _('Successfully reset all parameters of Puppet class %s to their default values') % @puppetclass.name
        end
      else
        error _('No parameters to override for Puppet class %s') % @puppetclass.name
      end
      redirect_to puppetclasses_path
    end

    # form AJAX methods
    def parameters
      puppetclass = Puppetclass.find(params[:id])
      render partial: 'foreman_puppet/puppetclasses/class_parameters',
             locals: { puppetclass: puppetclass,
                       obj: find_host_or_hostgroup }
    end

    def resource_class
      model_of_controller
    end

    private

    def find_host_or_hostgroup
      # params['host_id'] = 'undefined' if NEW since hosts/form and hostgroups/form has no data-id
      host_id = params.delete(:host_id)
      if host_id == 'undefined'
        @obj = Host::Managed.new(host_params('host')) if params['host']
        @obj ||= Hostgroup.new(hostgroup_params('hostgroup')) if params['hostgroup']
      elsif params['host']
        @obj = Host::Base.find(host_id)
        unless @obj.is_a?(Host::Managed)
          @obj      = @obj.becomes(Host::Managed)
          @obj.type = 'Host::Managed'
        end
        # puppetclass_ids and config_group_ids need to be removed so they don't cause automatic insertsgroup
        @obj.attributes = host_params('host')
      elsif params['hostgroup']
        # hostgroup.id is assigned to params['host_id'] by host_edit.js#load_puppet_class_parameters
        @obj = Hostgroup.find(host_id)
        @obj.attributes = hostgroup_params('hostgroup')
      end
      @obj
    end

    def action_permission
      case params[:action]
      when 'override'
        :edit
      else
        super
      end
    end
  end
end
