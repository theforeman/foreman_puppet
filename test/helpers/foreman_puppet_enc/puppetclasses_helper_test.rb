require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  class PuppetclassesHelperTest < ActionView::TestCase
    include PuppetclassesHelper

    describe '.overridden?' do
      setup do
        @env = FactoryBot.create(:environment)
      end

      it 'returns true when all params are overridden' do
        pc = FactoryBot.create(:puppetclass, :with_parameters, environments: [@env])
        pc.class_params.first.update(override: true)
        assert pc.class_params.first.override
        assert overridden?(pc)
      end

      it "returns false when one parameter isn't overridden" do
        pc = FactoryBot.create(:puppetclass, :with_parameters, parameter_count: 2, environments: [@env])
        pc.class_params.first.update(override: true)
        assert pc.class_params.first.override
        assert_not pc.class_params.last.override
        assert_not overridden?(pc)
      end

      it 'returns false when no parameters' do
        pc = FactoryBot.create(:puppetclass)
        assert_not overridden?(pc)
      end
    end
  end
end
