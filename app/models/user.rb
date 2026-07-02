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
  DELETED_SEASON_PENALTY = 3
  DELETED_PRODUCE_PENALTY = 1

  def multiplier
    # WIP put some logic here
    return 1
  end

  def karma
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
      score += 3 if season.confirmed?
    end

    # 3. Owned Produces: +1 per produce
    produces.each do |produce|
      produce.seasons.each do |season|
        score += 1
      end
    end

    # Penalty for owned seasons that got deleted
    score -= seasons_deleted_count.to_i * DELETED_SEASON_PENALTY

    # Penalty for produces that got deleted
    score -= produces_deleted_count.to_i * DELETED_PRODUCE_PENALTY

    score
  end
end
