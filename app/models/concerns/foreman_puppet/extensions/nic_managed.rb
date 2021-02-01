module ForemanPuppet
  module Extensions
    module NicManaged
      extend ActiveSupport::Concern

      included do
        delegate :environment_id, to: :host
      end
    end
  end
end
