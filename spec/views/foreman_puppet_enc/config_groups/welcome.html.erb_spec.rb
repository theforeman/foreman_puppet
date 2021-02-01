require 'spec_puppet_helper'

describe 'foreman_puppet/config_groups/welcome.html.erb' do
  it 'renders the welcome page' do
    assign(:welcome, true)

    render

    expect(rendered).to have_selector('a.btn-lg', text: 'Create Config Group')
  end
end
