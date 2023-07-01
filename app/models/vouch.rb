class Vouch < ApplicationRecord
  belongs_to :season
  belongs_to :user

  validates :value, inclusion: [true, false]

  after_save :delete_season, if: :should_delete_season?

  scope :upvoted, -> { where(value: true) }
  scope :downvoted, -> { where(value: false) }

  def prefix
    value ? 'up' : 'down'
  end

  def should_delete_season?
    season.score <= -3
  end

  def delete_season
    season.destroy
  end
end
