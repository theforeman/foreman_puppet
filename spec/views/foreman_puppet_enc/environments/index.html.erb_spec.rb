require 'spec_puppet_enc_helper'

describe 'foreman_puppet_enc/environments/index.html.erb' do
  context 'with 2 environments' do
    before(:each) do
      assign(:environments, as_paginatable([
                                             FactoryBot.build_stubbed(:environment, name: 'slicer'),
                                             FactoryBot.build_stubbed(:environment, name: 'dicer'),
                                           ]))
    end

    it 'displays both environments' do
      render

      expect(rendered).to include('slicer')
      expect(rendered).to include('dicer')
    end
  end
end
