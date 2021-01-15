require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  module InputType
    class PuppetParameterInputTest < ActiveSupport::TestCase
      let(:template_input) { FactoryBot.build(:template_input) }

      context 'puppet parameter input' do
        before { template_input.input_type = 'puppet_parameter' }
        it { assert_equal template_input.input_type_instance.class.humanized_name, _('Puppet parameter') }
      end
    end
  end
end
