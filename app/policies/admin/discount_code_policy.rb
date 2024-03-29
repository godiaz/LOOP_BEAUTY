class Admin::DiscountCodePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.where(active: true)
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    new?
  end

  def destroy?
    new?
  end

  def deactivate?
    new?
  end
end
