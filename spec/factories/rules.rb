FactoryBot.define do
  factory :rule do
    field           { "test_field" }
    operator        { "test_operator" }
    value           { "test_value" }
    sequence(:name) { "test_name_#{_1}" }
  end
end
