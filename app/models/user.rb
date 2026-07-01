class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  has_many :vouches, dependent: :destroy
  has_many :seasons, through: :vouches
  has_many :produces

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
    # Need to add has_many seasons association
    # seasons.each do |season|
    #   score += 3 if season.confirmed?
    # end

    # 3. Owned Produces: +1 per produce
    produces.each do |produce|
      produce.seasons.each do |season|
        score += 1
      end
    end
    score
  end
end
