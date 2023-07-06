class Produce < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true
  belongs_to :user
  has_many :links, dependent: :destroy
  has_many :seasons, dependent: :destroy
  has_one_attached :picture do |picture|
    picture.variant :thumb, resize_to_limit: [300, 300]
  end

  accepts_nested_attributes_for :links

  validates :user, presence: true

  def main_link
    wikilinks = links.wikipedia
    wikilinks.first.url if wikilinks.any?
  end

  def self.in_season(lat, lon)
    Produce.all.select { |produce| produce.in_season?(lat, lon) }
  end

  def in_season?(lat, lon)
    seasons.near([lat, lon], 500).each do |season|
      next unless season.ripe?
      return true
    end
    return false
  end
end
