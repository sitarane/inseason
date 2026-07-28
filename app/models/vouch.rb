class Vouch < ApplicationRecord
  belongs_to :season, touch: true
  belongs_to :user

  validates :value, inclusion: [true, false]

  after_save :notify_season
  after_save :notify_karma_manager
  after_destroy :notify_karma_manager

  scope :upvoted, -> { where(value: true) }
  scope :downvoted, -> { where(value: false) }

  def prefix
    value ? I18n.t(:upvote_prefix) : I18n.t(:downvote_prefix)
  end

  private

  def notify_season
    season&.reconcile_after_vouch_change!
  end

  def notify_karma_manager
    Karma::Manager.handle_vouch_change(self)
  end
end
