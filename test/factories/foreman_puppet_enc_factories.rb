FactoryBot.factories.instance_variable_get('@items').delete(:puppetclass_lookup_key) if FactoryBot.factories.registered?(:puppetclass_lookup_key)

FactoryBot.define do
  factory :puppetclass_lookup_key, parent: :lookup_key, class: 'ForemanPuppetEnc::PuppetclassLookupKey' do
    trait :as_smart_class_param do
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
end
