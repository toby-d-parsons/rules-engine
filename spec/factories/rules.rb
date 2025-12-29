FactoryBot.define do
  factory :rule do
    field           { "test_field" }
    operator        { "contains" }
    value           { "test_string_value" }
    sequence(:name) { "test_name_#{_1}" }

    trait :with_unparsed_value do
      # `unparsed value` is set by the controller from raw request params
      # Model specs bypass the controller, so this trait simulates request input.
      after(:build) do |rule|
        rule.unparsed_value = rule.value
      end
    end
  end
end
