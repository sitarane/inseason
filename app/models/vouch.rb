class Vouch < ApplicationRecord
  belongs_to :season, touch: true
  belongs_to :user

  validates :value, inclusion: [true, false]

  after_save :delete_season, if: :should_delete_season?
  after_save :update_season_confirmation_status

  scope :upvoted, -> { where(value: true) }
  scope :downvoted, -> { where(value: false) }

  def prefix
    value ? I18n.t(:upvote_prefix) : I18n.t(:downvote_prefix)
  end

  def should_delete_season?
    season.score <= -3
  end

  def delete_season
    season.destroy
  end

  private

  def update_season_confirmation_status
    new_status = season.score > 10
    season.update_column(:is_confirmed, new_status) if season.is_confirmed != new_status
  end
end
