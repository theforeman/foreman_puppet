FactoryBot.modify do
  factory :host do
    trait :with_puppet_enc do
      environment
      puppet { association :host_puppet_facet, :with_config_group }
    end
  end

  factory :hostgroup do
    trait :with_puppet_enc do
      environment
      puppet { association :hostgroup_puppet_facet, :with_config_group }
    end
  end
end
