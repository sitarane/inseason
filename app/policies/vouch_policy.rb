class VouchPolicy < ApplicationPolicy
  def create?
    return false unless user
    model.season.user != user
  end
end
