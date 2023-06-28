class VouchPolicy < ApplicationPolicy
  def create?
    return false unless user
    record.season.user != user
  end

  def update?
    user.present?
  end
end
