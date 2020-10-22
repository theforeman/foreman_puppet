require 'spec_puppet_enc_helper'

describe 'foreman_puppet_enc/puppetclasses/edit.html.erb', type: :view do
  it 'renders the form' do
    assign(:puppetclass, FactoryBot.build_stubbed(:puppetclass, name: 'Special'))

    render

    expect(rendered).to have_selector('input[name="puppetclass[name]"][value="Special"]')
  end
end
