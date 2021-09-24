require 'test_puppet_helper'

module ForemanPuppet
  class HostCounterTest < ActiveSupport::TestCase
    def hosts_count(association)
      ::HostCounter.new(association)
    end

    let(:environment) { FactoryBot.create(:environment) }

    test 'it should get number of hosts associated to environment' do
      FactoryBot.create(:host, :with_puppet_enc, environment: environment)
      count = hosts_count(:environment)
      assert_equal 1, count[environment]
    end
  end
end
