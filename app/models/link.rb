class Link < ApplicationRecord
  belongs_to :produce
  validates :from, presence: true
  validates :url, presence: true
  enum :from, [ :wikipedia ]
end
