module ForemanPuppet
  class EnvironmentsController < ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanPuppet::EnvironmentsImport
    include ForemanPuppet::Parameters::Environment

    before_action :find_resource, only: %i[edit update destroy]

    def index
      @environments = resource_base_search_and_page
      # AuthorizerHelper#authorizer uses controller_name as variable name, but it fails with namespaces
      @authorizer = Authorizer.new(User.current, collection: @environments)
    end

    def new
      @environment = model_of_controller.new
    end

    def create
      @environment = model_of_controller.new(environment_params)
      if @environment.save
        process_success
      else
        process_error
      end
    end

    def edit
    end

    def update
      if @environment.update(environment_params)
        process_success
      else
        process_error
      end
    end

    def destroy
      if @environment.destroy
        process_success
      else
        process_error
      end
    end

    def resource_class
      model_of_controller
    end
  end
end
