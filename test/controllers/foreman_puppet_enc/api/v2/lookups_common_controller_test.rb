require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  class DummyController < ForemanPuppetEnc::Api::V2::LookupsCommonController
    attr_accessor :params
  end

  class Api::V2::LookupsCommonControllerTest < ActiveSupport::TestCase
    setup do
      @dummy = DummyController.new
    end

    test "should cast default_value from smart class parameter" do
      @dummy.params = {:smart_class_parameter => { :default_value => ['a', 'b'] }}
      @dummy.cast_value(:smart_class_parameter, :default_value)
      assert_equal ['a', 'b'].to_s, @dummy.params[:smart_class_parameter][:default_value]
    end

    test "should cast value from override value" do
      @dummy.params = {:override_value => { :value => 123 }}
      @dummy.cast_value
      assert_equal "123", @dummy.params[:override_value][:value]
    end
  end
end
