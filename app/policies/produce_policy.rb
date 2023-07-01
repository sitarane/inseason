class ProducePolicy < ApplicationPolicy
  def update?
    return false unless user
    record.user == user
  end
  def edit?
    update?
  end
  def destroy?
    return false unless update?
    record.seasons.empty?
  end
end
