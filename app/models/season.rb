class Season < ApplicationRecord
  belongs_to :produce, touch: true
  belongs_to :user
  before_destroy :capture_vouches_for_recalculation
  has_many :vouches, dependent: :nullify
  has_many :users, through: :vouches

  validates :user, presence: true
  validates :latitude, :longitude, :start_time, :end_time, presence: true
  validates :latitude, inclusion: { in: -90..90 }
  validates :longitude, inclusion: { in: -180..180 }
  with_options if: :no_season? do |unseason|
    unseason.validates :start_time, numericality: { equal_to: -1 }
    unseason.validates :end_time, numericality: { equal_to: -1 }
  end

  reverse_geocoded_by :latitude, :longitude

  after_save :notify_karma_manager
  after_destroy :track_creator_penalty
  after_destroy :notify_karma_manager

  after_destroy :capture_vouches_for_recalculation

  def no_season?
    end_time&.<(0) || start_time&.<(0)
  end

  def confirmed?
    is_confirmed
  end

  def score
    reload
    score = 0
    vouches.each do |vouch|
      score += vouch.value ? 1 : -1 * vouch.user.multiplier
    end
    score
  end

  def ripe?
    current_week = DateTime.now.cweek # TODO check if timezone-proof
    if start_time <= end_time
      return true if current_week.between?(start_time, end_time)
      return false
    else
      return false if current_week.between?(end_time, start_time)
      return true
    end
  end

  private

  def capture_vouches_for_recalculation
    @vouches_to_recalculate = vouches.to_a
  end

  def track_creator_penalty
    user&.increment!(:seasons_deleted_count)
  end

  def notify_karma_manager
    if destroyed? && @vouches_to_recalculate.present?
      Karma::Manager.handle_season_destruction(self, @vouches_to_recalculate)
    else
      Karma::Manager.handle_season_change(self)
    end
  end
end
