class Produce < ApplicationRecord
  validates :name, presence: true
  has_many :links, dependent: :destroy
  has_one_attached :picture do |picture|
    picture.variant :thumb, resize_to_limit: [200, 200]
  end
end
