class Admin::LookbookPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.where(status: 'pending')
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def approve?
    user.admin?
  end

  def reject?
    approve?
  end
end
