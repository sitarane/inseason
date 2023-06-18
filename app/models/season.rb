class Season < ApplicationRecord
  belongs_to :produce
  has_many :vouches, dependent: :destroy
  has_many :users, through: :vouches
  validates :latitude, :longitude, :start_time, :end_time, presence: true
  validates :latitude, inclusion: { in: -90..90 }
  validates :longitude, inclusion: { in: -180..180 }

  reverse_geocoded_by :latitude, :longitude
end
