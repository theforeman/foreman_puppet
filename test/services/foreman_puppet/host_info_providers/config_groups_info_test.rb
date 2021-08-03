require 'test_puppet_helper'

module ForemanPuppet
  class ConfigGroupInfoTest < ActiveSupport::TestCase
    let(:cg_info) { HostInfoProviders::ConfigGroupsInfo.new(host) }

    context 'with Puppet Host' do
      let(:config_group) { FactoryBot.create(:config_group) }
      let(:host) do
        FactoryBot.build(:host, :with_puppet_enc,
          location: taxonomies(:location1),
          organization: taxonomies(:organization1),
          operatingsystem: operatingsystems(:redhat),
          config_groups: [config_group])
      end

      it 'adds config_groups to host parameters' do
        assert_equal([config_group.name], cg_info.host_info['parameters']['foreman_config_groups'])
      end
    end

    context 'without Puppet' do
      let(:host) do
        FactoryBot.build(:host,
          location: taxonomies(:location1),
          organization: taxonomies(:organization1),
          operatingsystem: operatingsystems(:redhat))
      end

      it 'does not fail without puppet facet' do
        assert_equal({}, cg_info.host_info)
      end
    end
  end
end
