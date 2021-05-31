require 'test_puppet_helper'

module ForemanPuppet
  module Api
    module V2
      class DummyLookupController < ForemanPuppet::Api::V2::PuppetLookupsCommonController
        attr_accessor :params
      end

      class LookupsCommonControllerTest < ActiveSupport::TestCase
        setup do
          @dummy = DummyLookupController.new
        end

        test 'should cast default_value from smart class parameter' do
          @dummy.params = { smart_class_parameter: { default_value: %w[a b] } }
          @dummy.cast_value(:smart_class_parameter, :default_value)
          assert_equal %w[a b].to_s, @dummy.params[:smart_class_parameter][:default_value]
        end

        test 'should cast value from override value' do
          @dummy.params = { override_value: { value: 123 } }
          @dummy.cast_value
          assert_equal '123', @dummy.params[:override_value][:value]
        end
      end
    end
  end
end
