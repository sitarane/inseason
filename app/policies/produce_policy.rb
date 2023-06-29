class ProducePolicy < ApplicationPolicy
  def update?
    return false unless user
    record.user == user
  end
  def edit?
    update?
  end
  def destroy?
    update?
  end
end
