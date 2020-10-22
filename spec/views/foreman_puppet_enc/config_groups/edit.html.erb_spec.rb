require 'spec_puppet_enc_helper'

describe 'foreman_puppet_enc/config_groups/edit.html.erb' do
  helper PuppetclassesHelper

  it 'renders the form' do
    config_group = FactoryBot.build_stubbed(:config_group, name: 'Special')
    config_group.stubs(:individual_puppetclasses).returns([FactoryBot.build_stubbed(:puppetclass)])
    config_group.stubs(:available_puppetclasses).returns([FactoryBot.build_stubbed(:puppetclass)])
    assign(:config_group, config_group)

    render

    expect(rendered).to have_selector('input[name="config_group[name]"][value="Special"]')
    expect(rendered).to have_selector('#selected_classes input[type="hidden"][name="config_group[puppetclass_ids][]"]', visible: false)
  end
end
