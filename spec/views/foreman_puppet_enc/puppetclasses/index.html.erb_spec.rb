require 'spec_puppet_enc_helper'

describe 'foreman_puppet_enc/puppetclasses/index.html.erb' do
  context 'with 2 puppetclasses' do
    before(:each) do
      hostgroup = FactoryBot.build_stubbed(:hostgroup, organizations: [FactoryBot.create(:organization)], locations: [FactoryBot.create(:location)])
      pc1 = FactoryBot.build_stubbed(:puppetclass, name: 'slicer')
      pc2 = FactoryBot.build_stubbed(:puppetclass, name: 'dicer')
      pc1.stubs(:all_hostgroups).returns([hostgroup])
      pc2.stubs(:all_hostgroups).returns([])
      assign(:puppetclasses, as_paginatable([pc1, pc2]))
    end

    it 'displays both puppetclasses' do
      render

      expect(rendered).to include('slicer')
      expect(rendered).to include('dicer')
    end
  end
end
