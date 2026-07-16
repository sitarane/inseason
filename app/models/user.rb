class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  has_many :vouches, dependent: :destroy
  has_many :vouched_seasons, through: :vouches
  has_many :seasons
  has_many :produces

  CONFIRMED_SEASON_KARMA = 3
  DELETED_SEASON_KARMA = -3
  DELETED_PRODUCE_KARMA = -1

  def multiplier(k: 0.1, nu: 1.5)
    # return 1
    numerator = 3.0
    
    # Calculate the inner part of the denominator: (3^nu - 1)
    asymmetry_constant = (3.0**nu) - 1.0
    
    # Calculate the exponential decay: e^(-k * x)
    exponential_term = Math.exp(-k * karma)
    
    # The denominator: (1 + constant * exponential)^(1/nu)
    denominator = (1.0 + asymmetry_constant * exponential_term)**(1.0 / nu)
    
    numerator / denominator
  end

  def recalculate_karma!
    update_column(:karma, calculate_karma)
  end

  def calculate_karma
    score = 0

    # 1. Votes (Vouches)
    vouches.each do |vouch|
      if vouch.season.present?
        if vouch.season.confirmed?
          score += vouch.value ? 1 : -1
        end
      else
        # Season was deleted
        score += vouch.value ? -1 : 1
      end
    end

    # 2. Owned Seasons: +3 if confirmed
    seasons.each do |season|
      score += CONFIRMED_SEASON_KARMA if season.confirmed?
    end

    # 3. Owned Produces: +1 per season
    produces.each do |produce|
      produce.seasons.each do |season|
        score += 1
      end
    end

    # Penalty for owned seasons that got deleted
    score += seasons_deleted_count.to_i * DELETED_SEASON_KARMA

    # Penalty for owned produces that got deleted
    score += produces_deleted_count.to_i * DELETED_PRODUCE_KARMA

    score
  end
end
