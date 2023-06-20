class Vouch < ApplicationRecord
  belongs_to :season
  belongs_to :user

  validates :value, inclusion: [true, false]

  scope :upvoted, -> { where(value: true) }
  scope :downvoted, -> { where(value: false) }

  def prefix
    value ? 'up' : 'down'
  end
end
