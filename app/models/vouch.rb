class Vouch < ApplicationRecord
  belongs_to :season, touch: true
  belongs_to :user

  validates :value, inclusion: [true, false]

  after_save :recalculate_voter_karma
  after_destroy :recalculate_voter_karma

  after_save :reconcile_season_state

  scope :upvoted, -> { where(value: true) }
  scope :downvoted, -> { where(value: false) }

  def prefix
    value ? I18n.t(:upvote_prefix) : I18n.t(:downvote_prefix)
  end

  private

  def recalculate_voter_karma
    user&.recalculate_karma!
  end

  def reconcile_season_state
    return unless season # season could have been deleted
    if season.score <= -3
      season.destroy
    else
      update_season_confirmation_status
    end
  end

  def update_season_confirmation_status
    new_status = season.score >= 10
    season.update_column(:is_confirmed, new_status) if season.is_confirmed != new_status
  end
end
