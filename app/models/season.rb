class Season < ApplicationRecord
  belongs_to :produce
  validates :latitude, :longitude, :start_time, :end_time, presence: true
  validates :latitude, inclusion: { in: -90..90 }
  validates :longitude, inclusion: { in: -180..180 }

  geocoded_by :place
  before_validation :geocode
end
