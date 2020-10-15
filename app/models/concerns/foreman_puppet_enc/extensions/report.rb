module ForemanPuppetEnc
  module Extensions
    module Report
      extend ActiveSupport::Concern

      included do
        has_one :environment, through: :host
      end
    end
  end
end
