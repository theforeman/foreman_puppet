module ForemanPuppet
  module Extensions
    module HostCommon
      extend ActiveSupport::Concern

      def all_puppetclasses(env = environment)
        return ForemanPuppet::Puppetclass.none unless puppet
        puppet.all_puppetclasses(env)
      end

      def puppetclasses
        (puppet || build_puppet).puppetclasses
      end
    end
  end
end
