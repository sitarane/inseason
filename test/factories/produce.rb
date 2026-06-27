FactoryBot.define do
  factory :produce do
    sequence(:name) { |n| "Produce #{n}" }
    association :user
  end
end
