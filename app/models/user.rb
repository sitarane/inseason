class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  has_many :vouches, dependent: :destroy
  has_many :vouched_seasons, through: :vouches
  has_many :seasons
  has_many :produces

  validates :email, presence: true, uniqueness: true

  def multiplier
    Karma::Calculator.multiplier_for(self)
  end

  def recalculate_karma!
    Karma::Manager.recalculate_user(self)
  end
end
