module ForemanPuppet
  class EnvironmentClass < ApplicationRecord
    self.table_name = 'environment_classes'

    belongs_to :environment
    belongs_to :puppetclass, inverse_of: :environment_classes
    belongs_to :puppetclass_lookup_key, inverse_of: :environment_classes, class_name: 'ForemanPuppet::PuppetclassLookupKey'
    validates :puppetclass_lookup_key_id, uniqueness: { scope: %i[environment_id puppetclass_id] }
    validates :puppetclass, :environment, presence: true
    after_destroy :delete_orphaned_lookup_keys

    scope :parameters_for_class, lambda { |puppetclasses_ids, environment_id|
      all_parameters_for_class(puppetclasses_ids, environment_id).where(puppetclass_lookup_keys: { override: true })
    }

    scope :all_parameters_for_class, lambda { |puppetclasses_ids, environment_id|
      where(puppetclass_id: puppetclasses_ids, environment_id: environment_id)
        .where.not(puppetclass_lookup_key_id: nil)
        .includes(:puppetclass_lookup_key)
    }

    scope :used_by_other_environment_classes, lambda { |puppetclass_lookup_key_id, this_environment_class_id|
      where(puppetclass_lookup_key_id: puppetclass_lookup_key_id)
        .where("id != #{this_environment_class_id}")
    }

    # TODO: move these into scopes?
    def self.is_in_any_environment(puppetclass, puppetclass_lookup_key)
      EnvironmentClass.where(puppetclass_id: puppetclass, puppetclass_lookup_key_id: puppetclass_lookup_key).any?
    end

    def self.key_in_environment(env, puppetclass, puppetclass_lookup_key)
      EnvironmentClass.find_by(environment_id: env, puppetclass_id: puppetclass, puppetclass_lookup_key_id: puppetclass_lookup_key)
    end

    def delete_orphaned_lookup_keys
      puppetclass_lookup_key.destroy if puppetclass_lookup_key.present? && puppetclass_lookup_key.environment_classes.empty?
    end
  end
end
