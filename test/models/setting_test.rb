require 'test_puppet_helper'

class SettingTest < ActiveSupport::TestCase
  test 'puppet_interval should not be zero' do
    check_zero_value_not_allowed_for 'puppet_interval'
  end
end
