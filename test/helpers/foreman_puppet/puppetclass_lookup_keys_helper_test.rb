require 'test_puppet_helper'

module ForemanPuppet
  class PuppetclassLookupKeysHelperTest < ActionView::TestCase
    include PuppetclassLookupKeysHelper

    describe '#overridable_puppet_lookup_keys' do
      let(:parent_puppet_var) { FactoryBot.create(:puppetclass_lookup_key) }
      let(:parent_hg) { FactoryBot.create(:hostgroup, :with_puppet_enc, environment: parent_puppet_var.environments.first) }

      context 'with new hostgroup' do
        subject do
          hg = Hostgroup.new(parent: parent_hg)
          hg.build_puppet
          hg
        end

        it 'returns inherited parameter' do
          keys = overridable_puppet_lookup_keys(parent_puppet_var.param_classes.first, subject)
          _(keys).must_include(parent_puppet_var)
        end
      end

      context 'with new host' do
        subject { Host.new(hostgroup: parent_hg) }

        it 'returns inherited parameter' do
          keys = overridable_puppet_lookup_keys(parent_puppet_var.param_classes.first, subject)
          _(keys).must_include(parent_puppet_var)
        end
      end
    end
  end
end
