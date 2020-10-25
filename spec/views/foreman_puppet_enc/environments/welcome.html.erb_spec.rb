require 'spec_puppet_enc_helper'

describe 'foreman_puppet_enc/environments/welcome.html.erb' do
  it 'renders the welcome page' do
    assign(:welcome, true)

    render

    expect(rendered).to have_selector('a.btn-lg', text: 'Create Puppet Environment')
  end
end
