module ForemanPuppet
  class ConfigGroupsController < ::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanPuppet::Parameters::ConfigGroup

    before_action :find_resource, only: %i[edit update destroy]

    helper PuppetclassesHelper

    def index
      @config_groups = resource_base_search_and_page
    end

    def new
      @config_group = ForemanPuppet::ConfigGroup.new
    end

    def edit
    end

    def create
      @config_group = ForemanPuppet::ConfigGroup.new(config_group_params)
      if @config_group.save
        process_success
      else
        process_error
      end
    end

    def update
      if @config_group.update(config_group_params)
        process_success
      else
        process_error
      end
    end

    def destroy
      if @config_group.destroy
        process_success
      else
        process_error
      end
    end
  end
end
