class Admin::BrandPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
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
end

