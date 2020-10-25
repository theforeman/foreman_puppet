require 'spec_puppet_enc_helper'

describe 'foreman_puppet_enc/environments/edit.html.erb' do
  it 'renders the form' do
    assign(:environment, FactoryBot.build_stubbed(:environment, name: 'Special'))

    render

    expect(rendered).to have_selector('li.active a[href="#primary"]')
    expect(rendered).to have_selector('.tab-pane', count: 3)
    expect(rendered).to have_selector('input[name="environment[name]"][value="Special"]')
  end
end
