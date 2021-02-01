require 'test_puppet_helper'

module ForemanPuppet
  class TemplateRenderingTest < ActiveSupport::TestCase
    let(:host) { FactoryBot.build_stubbed(:host, :with_puppet_enc) }
    let(:template) { OpenStruct.new(name: 'Test', template: 'Test') }
    let(:source) { Foreman::Renderer::Source::Database.new(template) }
    let(:scope) do
      Class.new(Foreman::Renderer::Scope::Base) do
        include Foreman::Renderer::Scope::Macros::HostTemplate
      end.send(:new, host: host, source: source)
    end

    describe '#host_puppet_classes' do
      test 'should render puppetclasses using host_puppetclasses helper' do
        assert_equal host.puppet.puppetclasses.pluck(:id), scope.host_puppet_classes.map(&:id)
      end
    end
  end
end
