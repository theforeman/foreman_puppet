module ForemanPuppetEnc
  module Extensions
    module TemplateCombination
      extend ActiveSupport::Concern

      included do
        if ForemanPuppetEnc.extracted_from_core?
          belongs_to :environment

          validates :environment_id, uniqueness: { scope: %i[hostgroup_id provisioning_template_id] }
        else
          env_assoc = reflect_on_association(:environment)
          env_assoc.instance_variable_set(:@class_name, 'ForemanPuppetEnc::Environment')
        end
      end
    end
  end
end
