module Karma
  class Calculator
    CONFIRMED_SEASON_KARMA = 3
    DELETED_SEASON_KARMA = -3
    DELETED_PRODUCE_KARMA = -1

    def self.calculate_for_user(user)
      score = 0
      
      # 1. Vouches
      user.vouches.each do |vouch|
        season = vouch.season
        if season.present? && !season.destroyed?
          if season.is_confirmed?
            score += vouch.value ? 1 : -1
          end
        else
          # Season was deleted
          score += vouch.value ? -1 : 1
        end
      end

      # 2. Owned Seasons
      user.seasons.each do |season|
        score += CONFIRMED_SEASON_KARMA if season.is_confirmed?
      end

      # 3. Owned Produces
      user.produces.each do |produce|
        produce.seasons.each do |season|
          score += 1
        end
      end

      # 4. Penalties for deletions
      score += user.seasons_deleted_count.to_i * DELETED_SEASON_KARMA
      score += user.produces_deleted_count.to_i * DELETED_PRODUCE_KARMA

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
