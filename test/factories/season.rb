FactoryBot.define do
  factory :season do
    user
    produce
    latitude { 52.0 } # Berlin
    longitude { 13.0 }
    start_time { 130 } # May
    end_time { 180 }   # June
  end

  trait :confirmed do
    after(:create) do |season|                                                                                                                                                                                                               
      create_list(:vouch, 11, season: season, value: true)                                                                                                                                                                                   
    end
  end
end