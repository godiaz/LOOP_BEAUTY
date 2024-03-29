class AddressPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def destroy?
    record.user == user || user.admin?
  end

  def set_default?
    record.user == user
  end
end
