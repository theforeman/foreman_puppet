require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  class ConfigGroupTest < ActiveSupport::TestCase
    should validate_presence_of(:name)
    should validate_uniqueness_of(:name)
  end
end
