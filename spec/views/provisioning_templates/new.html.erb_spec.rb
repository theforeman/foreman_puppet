require 'spec_puppet_helper'

describe 'provisioning_templates/new.html.erb' do
  let!(:environment) { FactoryBot.create(:environment, name: 'SpecialEnv') }

  it 'renders the template combination selection with environment' do
    template = ProvisioningTemplate.new
    assign(:template, template)
    assign(:operatingsystems, [FactoryBot.build_stubbed(:operatingsystem)])

    view.stubs(:snippet_message).returns('')
    view.expects(:how_templates_are_determined)

    view.form_for template do |f|
      render partial: 'provisioning_templates/custom_tabs.html.erb', locals: { f: f }
    end
    # expect(rendered).to have_selector(
    #   "select[name='provisioning_template[template_combinations_attributes][new_template_combinations][environment_id]'] option[value='#{environment.id}']"
    # )
  end
end
