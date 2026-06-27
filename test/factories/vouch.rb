FactoryBot.define do
  factory :vouch do
    user
    season
    value { true }
  end
end