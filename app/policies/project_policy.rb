class ProjectPolicy < ApplicationPolicy
  # user = current_user, record = @project

  def index?
    # CEO and Admin see everything
    user.role_ceo? || user.role_admin? ||
    # Other roles with project visibility
    user.role_cto? || user.role_site_manager? || user.role_qs? ||
    user.role_engineer? || user.role_storekeeper? || user.role_hr?
  end

  def show?
    index?
  end

  def create?
    # CEO, Admin, CTO, Manager can create projects
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager?
  end

  def update?
    # CEO, Admin, CTO, Manager can update projects
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager?
  end

  def destroy?
    # CEO and Admin have destructive power, CTO optionally
    user.role_ceo? || user.role_admin? || user.role_cto?
  end

  class Scope < Scope
    def resolve
      if user.role_engineer? || user.role_qs?
        # Engineers/QS only see projects where they have tasks assigned
        scope.joins(tasks: :assignments)
             .where(assignments: { user_id: user.id })
             .distinct
      else
        # All other roles see all projects (company-owned)
        scope.all
      end
    end
  end
end
