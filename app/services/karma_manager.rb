module Karma
  class Manager
    def self.recalculate_user(user)
      return unless user
      new_score = Calculator.calculate_for_user(user)
      user.update!(karma: new_score)
    end

    def self.recalculate_user_with_context(user, context_record)
      return unless user
      # In the current implementation, the calculation is global per user
      # but we pass context if we wanted to optimize. 
      # For now, we maintain the existing logic of full recalculation.
      recalculate_user(user)
    end

    def self.handle_season_change(season)
      # Recalculate owner
      recalculate_user(season.user)
      # Recalculate produce owner
      recalculate_user(season.produce.user)
      
      # If season is confirmed/unconfirmed, recalculate voters
      if season.saved_change_to_is_confirmed? || season.destroyed?
        season.vouches.each do |vouch|
          recalculate_user(vouch.user)
        end
      end
    end

    def self.handle_produce_change(produce)
      recalculate_user(produce.user)
    end

    def self.handle_vouch_change(vouch)
      recalculate_user(vouch.user)
      # Also handle the season side effects
      handle_season_change(vouch.season) if vouch.season
    end
  end
end
