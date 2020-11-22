module ForemanPuppetEnc
  module Extensions
    module Hostgroup
      extend ActiveSupport::Concern

      included do
        if ForemanPuppetEnc.extracted_from_core?
          # has_one :environment, through: :puppet
        else
          env_assoc = reflect_on_association(:environment)
          env_assoc.instance_variable_set(:@class_name, 'ForemanPuppetEnc::Environment')
        end

        # Facets preceeds SelectiveClone include, so include_in_clone isn't available yet - nasty fix
        include SelectiveClone

        include_in_clone :puppet
      end
    end
  end
end
