FactoryBot.modify do
  factory :host do
    trait :with_puppetclass do
      transient do
        environment
      end
      puppetclasses { [FactoryBot.create(:puppetclass, environments: [environment])] }
    end

    trait :with_puppet_enc do
      transient do
        environment
      end
      puppet { association :host_puppet_facet, :with_config_group, environment: environment }
      puppet_proxy do
        FactoryBot.create(:smart_proxy, features: [FactoryBot.create(:feature, :puppet)])
      end
    end
  end

  factory :hostgroup do
    trait :with_puppetclass do
      transient do
        environment
      end
      puppetclasses { [FactoryBot.create(:puppetclass, environments: [environment])] }
    end

    trait :with_puppet_enc do
      transient do
        environment
      end
      puppet { association :hostgroup_puppet_facet, :with_config_group, environment: environment }
      puppet_proxy do
        FactoryBot.create(:smart_proxy, features: [FactoryBot.create(:feature, :puppet)])
      end
    end
  end
end
