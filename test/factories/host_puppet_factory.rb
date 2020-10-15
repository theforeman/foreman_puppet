FactoryBot.modify do
  factory :host do
    transient do
      environment
    end
    puppet { association :host_facet, environment: environment }
  end
end
