module ForemanPuppetEnc
  module Extensions
    module Host
      extend ActiveSupport::Concern

      included do
        if ForemanPuppetEnc.extracted_from_core?
          # has_one :environment, through: :puppet
        else
          env_assoc = reflect_on_association(:environment)
          env_assoc&.instance_variable_set(:@class_name, 'ForemanPuppetEnc::Environment')
        end
      end
    end
  end
end
