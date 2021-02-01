require 'spec_puppet_helper'

describe 'foreman_puppet/environments/new.html.erb' do
  it 'renders the form' do
    assign(:environment, Environment.new)

    render

    expect(rendered).to have_selector('li.active a[href="#primary"]')
    expect(rendered).to have_selector('.tab-pane', count: 3)
    expect(rendered).to have_selector('input[name="environment[name]"]')
  end
end
