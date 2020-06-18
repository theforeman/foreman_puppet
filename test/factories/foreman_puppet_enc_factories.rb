if FactoryBot.factories.registered?(:puppetclass_lookup_key)
  FactoryBot.factories.instance_variable_get('@items').delete(:puppetclass_lookup_key)
end

FactoryBot.define do
  factory :puppetclass_lookup_key, parent: :lookup_key, class: 'ForemanPuppetEnc::PuppetclassLookupKey' do
    trait :as_smart_class_param do
      transient do
        puppetclass { nil }
      end
      after(:create) do |lkey, evaluator|
        evaluator.puppetclass&.environments&.each do |env|
          FactoryBot.create :environment_class, :puppetclass => evaluator.puppetclass, :environment => env, :puppetclass_lookup_key_id => lkey.id
        end
      end
    end
  end
end
