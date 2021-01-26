FactoryBot.modify do
  factory :host do
    trait :with_puppetclass do
      transient do
        environment
        puppetclasses { [FactoryBot.create(:puppetclass, environments: [environment])] }
      end
    end

    trait :with_config_group do
      environment
      config_groups { [FactoryBot.create(:config_group, :with_puppetclass, class_environments: [environment])] }
    end

    trait :with_puppet_enc do
      transient do
        environment
        puppetclasses { [] }
        config_groups { [] }
      end
      puppet { association :host_puppet_facet, :with_config_group, environment: environment, puppetclasses: puppetclasses, config_groups: config_groups }
      puppet_proxy do
        FactoryBot.create(:smart_proxy, features: [FactoryBot.create(:feature, :puppet)])
      end
    end
  end

  factory :hostgroup do
    trait :with_puppetclass do
      transient do
        environment
        puppetclasses { [FactoryBot.create(:puppetclass, environments: [environment])] }
      end
    end

    trait :with_config_group do
      config_groups { [FactoryBot.create(:config_group, :with_puppetclass, class_environments: [environment])] }
    end

    trait :with_puppet_enc do
      transient do
        environment
        puppetclasses { [] }
        config_groups { [] }
      end
      puppet { association :hostgroup_puppet_facet, :with_config_group, environment: environment, puppetclasses: puppetclasses, config_groups: config_groups }
      puppet_proxy do
        FactoryBot.create(:smart_proxy, features: [FactoryBot.create(:feature, :puppet)])
      end
    end
  end

  factory :template_combination do
    environment
  end
end
