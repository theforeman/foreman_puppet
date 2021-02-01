module ForemanPuppet
  module Extensions
    module TemplateCombination
      extend ActiveSupport::Concern

      included do
        if ForemanPuppet.extracted_from_core?
          belongs_to :environment

          validates :environment_id, uniqueness: { scope: %i[hostgroup_id provisioning_template_id] }

          callback = __callbacks[:validate].detect do |v|
            v.filter.is_a?(ActiveRecord::Validations::UniquenessValidator) && v.filter.attributes.include?(:hostgroup_id)
          end
          callback.filter.options[:scope] << :environment_id
        else
          env_assoc = reflect_on_association(:environment)
          env_assoc&.instance_variable_set(:@class_name, 'ForemanPuppet::Environment')
        end
      end
    end
  end
end
