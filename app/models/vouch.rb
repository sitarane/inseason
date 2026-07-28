class Vouch < ApplicationRecord
  belongs_to :season, touch: true
  belongs_to :user

  validates :value, inclusion: [true, false]

  after_save :reconcile_season_state
  after_save :notify_karma_manager
  after_destroy :notify_karma_manager

  scope :upvoted, -> { where(value: true) }
  scope :downvoted, -> { where(value: false) }

  def prefix
    value ? I18n.t(:upvote_prefix) : I18n.t(:downvote_prefix)
  end

  private

  def notify_karma_manager
    Karma::Manager.handle_vouch_change(self)
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
    is_high_score = season.score >= 10
    return if season.is_confirmed == is_high_score
    season.update!(is_confirmed: is_high_score)
  end
end
