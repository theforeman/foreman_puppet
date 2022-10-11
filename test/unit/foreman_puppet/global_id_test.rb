require 'test_puppet_helper'

module ForemanPuppet
  class GlobalIdTest < ActiveSupport::TestCase
    describe '.for' do
      let(:environment) { FactoryBot.create(:environment) }

      test 'generates id that contains modulized model name' do
        assert_equal Foreman::GlobalId.encode('ForemanPuppet::Environment', environment.id), Foreman::GlobalId.for(environment)
      end
    end
  end
end
