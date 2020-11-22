require 'test_puppet_helper'

module ForemanPuppet
  class ConfigGroupClassTest < ActiveSupport::TestCase
    should validate_presence_of(:config_group)
    should validate_presence_of(:puppetclass)
    # can not validate_uniqueness_of associations
    # https://github.com/thoughtbot/shoulda-matchers/issues/814
    # should validate_uniqueness_of(:config_group).scoped_to(:puppetclass_id)
  end
end
