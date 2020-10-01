FactoryBot.factories.instance_variable_get('@items').delete(:puppetclass) if FactoryBot.factories.registered?(:puppetclass)
FactoryBot.factories.instance_variable_get('@items').delete(:puppetclass_lookup_key) if FactoryBot.factories.registered?(:puppetclass_lookup_key)

FactoryBot.define do
  factory :puppetclass do
    sequence(:name) { |n| "class#{n}" }

    transient do
      environments { [] }
    end
    after(:create) do |pc, evaluator|
      evaluator.environments.each do |env|
        FactoryBot.create :environment_class, puppetclass: pc, environment: env unless env.nil?
      end
    end

    trait :with_parameters do
      transient do
        parameter_count { 1 }
      end
      after(:create) do |pc, evaluator|
        evaluator.parameter_count.times do
          evaluator.environments.each do |env|
            FactoryBot.create :puppetclass_lookup_key, override: false, puppetclass: pc, environment: env
          end
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
      environment = evaluator.environment || evaluator.puppetclass.environments.first
      environment ||= FactoryBot.create(:environment)
      FactoryBot.create :environment_class, puppetclass: evaluator.puppetclass, environment: environment, puppetclass_lookup_key_id: lkey.id
    end
  end
end
