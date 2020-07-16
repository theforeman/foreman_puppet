require 'test_puppet_enc_helper'

class ForemanPuppetEncTest < ActiveSupport::TestCase
  setup do
    User.current = User.find_by(login: 'admin')
  end

  test 'the truth' do
    assert true
  end
end
