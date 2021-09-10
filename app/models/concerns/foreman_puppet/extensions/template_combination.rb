module ForemanPuppet
  module Extensions
    module TemplateCombination
      extend ActiveSupport::Concern

      included do
        belongs_to :environment, class_name: 'ForemanPuppet::Environment'

        validates :environment_id, uniqueness: { scope: %i[hostgroup_id provisioning_template_id] }

        callback = __callbacks[:validate].detect do |v|
          v.filter.is_a?(ActiveRecord::Validations::UniquenessValidator) && v.filter.attributes.include?(:hostgroup_id)
        end
        callback.filter.options[:scope] << :environment_id
      end
    end
  end
end
