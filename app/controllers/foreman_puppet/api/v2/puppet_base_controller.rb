module ForemanPuppet
  module Api
    module V2
      class PuppetBaseController < ::Api::V2::BaseController
        resource_description do
          api_version 'v2'
        end
      end
    end
  end
end
