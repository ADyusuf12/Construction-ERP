class TaskPolicy < ApplicationPolicy
  # user = current_user, record = @task

  def index?
    # CEO/Admin see everything
    user.role_ceo? || user.role_admin? ||
    # Other roles with task visibility
    user.role_cto? || user.role_site_manager? || user.role_qs? || user.role_engineer?
  end

  def show?
    index?
  end

  def create?
    # CEO/Admin/CTO/Site Manager can create tasks
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager?
  end

  def update?
    # CEO/Admin/CTO/Site Manager can update tasks
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager?
  end

  def destroy?
    # CEO/Admin/CTO can destroy tasks
    user.role_ceo? || user.role_admin? || user.role_cto?
  end

  def mark_in_progress?
    # CEO/Admin/CTO/Site Manager can move tasks forward
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager?
  end

  def mark_done?
    # CEO/Admin/CTO/Site Manager can mark tasks complete
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager?
  end

  class Scope < Scope
    def resolve
      if user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager?
        scope.all
      else
        # QS/Engineer only see tasks assigned to them
        scope.joins(:assignments).where(assignments: { user_id: user.id })
      end
    end
  end
end
