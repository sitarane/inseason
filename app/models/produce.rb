class Produce < ApplicationRecord
  validates :name, presence: true
  has_many :links, dependent: :destroy
  has_one_attached :picture do |picture|
    picture.variant :thumb, resize_to_limit: [300, 300]
  end

  accepts_nested_attributes_for :links

  def main_link
    wikilinks = links.wikipedia
    wikilinks.first.url if wikilinks.any?
  end
end
