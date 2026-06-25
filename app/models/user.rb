class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  has_many :vouches, dependent: :destroy
  has_many :seasons, through: :vouches

  def multiplier
    # WIP put some logic here
    return 1
  end
end
