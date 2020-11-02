FactoryBot.modify do
  factory :feature do
    trait :puppet do
      name { 'Puppet' }
    end
  end

  factory :smart_proxy_feature do
    trait :puppet do
      association :feature, :puppet
    end
  end
end

FactoryBot.factories.instance_variable_get('@items').delete(:puppet_smart_proxy) if FactoryBot.factories.registered?(:puppet_smart_proxy)
FactoryBot.factories.instance_variable_get('@items').delete(:puppet_and_ca_smart_proxy) if FactoryBot.factories.registered?(:puppet_and_ca_smart_proxy)
FactoryBot.define do
  factory :puppet_smart_proxy, parent: :smart_proxy do
    before(:create, :build, :build_stubbed) do
      ProxyAPI::V2::Features.any_instance.stubs(:features).returns(puppet: { 'state' => 'running' })
    end
    after(:build) do |smart_proxy, _evaluator|
      smart_proxy.smart_proxy_features << FactoryBot.build(:smart_proxy_feature, :puppet, smart_proxy: smart_proxy)
    end
  end

  factory :puppet_and_ca_smart_proxy, parent: :smart_proxy do
    after(:build) do |smart_proxy, _evaluator|
      smart_proxy.smart_proxy_features << FactoryBot.build(:smart_proxy_feature, :puppet, smart_proxy: smart_proxy)
      smart_proxy.smart_proxy_features << FactoryBot.build(:smart_proxy_feature, :puppetca, smart_proxy: smart_proxy)
    end
  end
end
