require 'test_plugin_helper'

class ForemanPuppetEncTest < ActiveSupport::TestCase
  setup do
    User.current = User.find_by(login: 'admin')
  end

  test 'the truth' do
    assert true
  end
end
