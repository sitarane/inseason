class Produce < ApplicationRecord
  validates :name, presence: true
  has_many :links, dependent: :destroy
end
