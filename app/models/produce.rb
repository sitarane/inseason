class Produce < ApplicationRecord
  extend FriendlyId
  extend Mobility

  friendly_id :name, use: :slugged

  translates :name

  validates :name, presence: true, uniqueness: true
  belongs_to :user
  has_many :links, dependent: :destroy
  has_many :seasons, dependent: :destroy
  has_one_attached :picture do |picture|
    picture.variant :thumb, resize_to_limit: [300, 300]
  end

  after_create :make_sure_the_slug_is_english

  accepts_nested_attributes_for :links

  validates :user, presence: true

  def make_sure_the_slug_is_english
    # This is ugly. But friendly_id behaves unexpectedly when I try to use
    # a setter method before the produce is saved
    self.slug = nil
    I18n.with_locale(:en) do
      self.save
    end
  end

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

  def self.season_unknown(lat, lon)
    Produce.all.select { |produce| !produce.has_season?(lat, lon) }
  end

  def has_season?(lat, lon)
    seasons.near([lat, lon], 500).any?
  end
end
