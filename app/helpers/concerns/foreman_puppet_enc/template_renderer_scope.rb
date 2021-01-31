module ForemanPuppetEnc
  module TemplateRendererScope
    extend ActiveSupport::Concern
    extend ApipieDSL::Module

    apipie :method, 'Returns puppet classes assigned to the host' do
      returns Array, desc: 'Puppet classes assigned to the host'
    end
    def host_puppet_classes
      check_host
      host.puppet&.puppetclasses || []
    end
  end
end
