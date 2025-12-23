class ProjectPolicy < ApplicationPolicy
  # user = current_user, record = @project

  def index?
    # CEO and Admin see everything
    user.role_ceo? || user.role_admin? ||
    # Other roles with project visibility
    user.role_cto? || user.role_manager? || user.role_qs? || user.role_engineer? || user.role_storekeeper? || user.role_hr?
  end

  def show?
    index?
  end

  def create?
    # CEO, Admin, CTO, Manager can create projects
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_manager?
  end

  def update?
    # CEO, Admin, CTO, Manager can update projects
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_manager?
  end

  def destroy?
    # CEO and Admin have destructive power, CTO optionally
    user.role_ceo? || user.role_admin? || user.role_cto?
  end

  class Scope < Scope
    def resolve
      if user.role_ceo? || user.role_admin? || user.role_cto? || user.role_manager? || user.role_hr? || user.role_storekeeper?
        scope.all
      else
        # QS, Engineer, etc. only see projects they are assigned to
        scope.joins(:assignments).where(assignments: { user_id: user.id })
      end
    end
  end
end
