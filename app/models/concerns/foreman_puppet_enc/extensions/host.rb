module ForemanPuppetEnc
  module Extensions
    module Host
      extend ActiveSupport::Concern

      included do
        has_one :environment, through: :host_puppet_extension
      end
    end
  end
end
