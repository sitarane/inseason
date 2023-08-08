class VouchPolicy < ApplicationPolicy
  def create?
    return false unless user.try(:confirmed?)
    record.season.user != user
  end

  def update?
    return false unless create?
    record.user == user
  end
end
