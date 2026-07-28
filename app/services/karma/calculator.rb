module Karma
  class Calculator
    VOUCHED_FOR_CONFIRMED_SEASON = 1
    VOUCHED_FOR_DELETED_SEASON = -1
    CREATED_CONFIRMED_SEASON = 3
    CREATED_DELETED_SEASON = -3
    CREATED_DELETED_PRODUCE = -1
    SEASON_IN_CREATED_PRODUCE = 1

    def self.calculate_for_user(user)
      score = 0
      
      # 1. Vouches
      user.vouches.each do |vouch|
        season = vouch.season
        if season.present? && !season.destroyed?
          if season.is_confirmed?
            score += vouch.value ? VOUCHED_FOR_CONFIRMED_SEASON : -VOUCHED_FOR_CONFIRMED_SEASON
          end
        else
          # Season was deleted
          score += vouch.value ? VOUCHED_FOR_DELETED_SEASON : -VOUCHED_FOR_DELETED_SEASON
        end
      end

      # 2. Owned Seasons
      user.seasons.each do |season|
        score += CREATED_CONFIRMED_SEASON if season.is_confirmed?
      end

      # 3. Owned Produces
      user.produces.each do |produce|
        produce.seasons.each do |season|
          score += SEASON_IN_CREATED_PRODUCE
        end
      end

      # 4. Penalties for deletions
      score += user.seasons_deleted_count.to_i * CREATED_DELETED_SEASON
      score += user.produces_deleted_count.to_i * CREATED_DELETED_PRODUCE

      score
    end

    def self.multiplier_for(user)
      # Using the existing formula logic
      # We use a local variable to avoid infinite recursion if called within calculate
      k = user.karma
      nu = 1.5
      
      numerator = 3.0
      asymmetry_constant = (3.0**nu) - 1.0
      exponential_term = Math.exp(-k * 0.1)
      denominator = (1.0 + asymmetry_constant * exponential_term)**(1.0 / nu)
      
      numerator / denominator
    end
  end
end
