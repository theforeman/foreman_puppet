FactoryBot.factories.instance_variable_get('@items').delete(:environment) if FactoryBot.factories.registered?(:environment)
FactoryBot.factories.instance_variable_get('@items').delete(:environment_class) if FactoryBot.factories.registered?(:environment_class)
FactoryBot.factories.instance_variable_get('@items').delete(:puppetclass) if FactoryBot.factories.registered?(:puppetclass)
FactoryBot.factories.instance_variable_get('@items').delete(:puppetclass_lookup_key) if FactoryBot.factories.registered?(:puppetclass_lookup_key)

FactoryBot.define do
  factory :common_puppet_facet do
  end

  factory :host_puppet_facet, parent: :common_puppet_facet, class: 'ForemanPuppetEnc::HostPuppetFacet' do
    host

    trait :with_config_group do
      config_groups { [FactoryBot.create(:config_group, :with_puppetclass, class_environments: [host.environment])] }
    end
  end

  factory :hostgroup_puppet_facet, parent: :common_puppet_facet, class: 'ForemanPuppetEnc::HostgroupPuppetFacet' do
    hostgroup

    trait :with_config_group do
      config_groups { [FactoryBot.create(:config_group, :with_puppetclass, class_environments: [hostgroup.environment])] }
    end
  end

  factory :environment do
    sequence(:name) { |n| "environment#{n}" }
    organizations { [Organization.first || create(:organization)] }
    locations { [Location.first || create(:location)] }

    transient do
      puppetclasses { [] }
    end

    trait :with_puppetclass do
      transient do
        puppetclasses { [create(:puppetclass)] }
      end
    end

    after(:create) do |environment, evaluator|
      evaluator.puppetclasses.each do |pc|
        create(:environment_class, environment: environment, puppetclass: pc)
      end
    end
  end

  factory :environment_class do
    environment
    puppetclass
  end

  factory :puppetclass do
    sequence(:name) { |n| "class#{n}" }

    transient do
      environments { [] }
      parameter_count { 0 }
    end

    trait :with_parameters do
      transient do
        environments { [create(:environment)] }
        parameter_count { 1 }
      end
    end

    after(:create) do |pc, evaluator|
      if evaluator.parameter_count.positive?
        evaluator.parameter_count.times do
          evaluator.environments.each do |env|
            FactoryBot.create :puppetclass_lookup_key, override: false, puppetclass: pc, environment: env
          end
        end
      else
        evaluator.environments.each do |env|
          FactoryBot.create :environment_class, puppetclass: pc, environment: env unless env.nil?
        end
      end
    end
  end

  factory :puppetclass_lookup_key, parent: :lookup_key, class: 'ForemanPuppetEnc::PuppetclassLookupKey' do
    override { true }

    transient do
      puppetclass { create(:puppetclass) }
      environment { nil }
    end

    after(:create) do |lkey, evaluator|
      environments = evaluator.puppetclass.environments.to_a + [evaluator.environment].compact
      environments = [FactoryBot.create(:environment)] unless environments.any?
      environments.each do |env|
        FactoryBot.create :environment_class, puppetclass: evaluator.puppetclass, environment: env, puppetclass_lookup_key_id: lkey.id
      end
    end
  end
end
