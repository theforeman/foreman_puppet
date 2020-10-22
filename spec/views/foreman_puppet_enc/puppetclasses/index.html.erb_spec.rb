require 'spec_puppet_enc_helper'

describe 'foreman_puppet_enc/puppetclasses/index.html.erb' do
  context 'with 2 puppetclasses' do
    before(:each) do
      assign(:puppetclasses, as_paginatable([
                                              FactoryBot.build_stubbed(:puppetclass, name: 'slicer'),
                                              FactoryBot.build_stubbed(:puppetclass, name: 'dicer'),
                                            ]))
    end

    it 'displays both puppetclasses' do
      render

      expect(rendered).to include('slicer')
      expect(rendered).to include('dicer')
    end
  end
end
