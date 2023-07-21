class Link < ApplicationRecord
  extend Mobility

  translates :url

  belongs_to :produce

  validates :from, presence: true
  validates :url, presence: true
  validates :url, http_url: true

  enum :from, [ :wikipedia ]
end
