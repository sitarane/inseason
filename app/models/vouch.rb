class Vouch < ApplicationRecord
  belongs_to :season
  belongs_to :user

  validates :value, presence: true

  scope :upvoted, -> { where(value: true) }
  scope :downvoted, -> { where(value: false) }
end
