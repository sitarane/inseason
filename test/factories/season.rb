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
      create_list(:vouch, 10, season: season, value: true)            
    end
  end

  trait :score_of_5_mixed do
    after(:create) do |season|
      create_list(:vouch, 4, season: season, value: true)
      create_list(:vouch, 2, season: season, value: false)
      create_list(:vouch, 2, season: season, value: true)
    end
  end

  trait :score_of_9_mixed do
    after(:create) do |season|
      create_list(:vouch, 7, season: season, value: true)
      create_list(:vouch, 2, season: season, value: false)
      create_list(:vouch, 4, season: season, value: true)
    end
  end
end