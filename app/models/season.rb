class Season < ApplicationRecord
  belongs_to :produce
  belongs_to :user
  has_many :vouches, dependent: :destroy
  has_many :users, through: :vouches

  validates :user, presence: true
  validates :latitude, :longitude, :start_time, :end_time, presence: true
  validates :latitude, inclusion: { in: -90..90 }
  validates :longitude, inclusion: { in: -180..180 }

  reverse_geocoded_by :latitude, :longitude

  def confirmed?
    if vouches.count > 10
      score > 5
    else
      score > 0
    end
  end

  def score
    score = 0
    vouches.each do |vouch|
      if vouch.value
        score += 1
      else
        score -= 1
      end
    end
    score
  end
end
