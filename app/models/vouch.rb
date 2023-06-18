class Vouch < ApplicationRecord
  belongs_to :season
  belongs_to :user

  validates :value, presence: true
end
