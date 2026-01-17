class ProjectExpensePolicy < ApplicationPolicy
  # user = current_user, record = @expense

  def index?
    # Broad visibility for most roles
    user.role_ceo? || user.role_admin? ||
    user.role_accountant? || user.role_cto? ||
    user.role_site_manager? || user.role_engineer? ||
    user.role_storekeeper? || user.role_hr?
  end

  def show?
    index?
  end

  def create?
    # Finance + leadership + site managers can record expenses
    user.role_ceo? || user.role_admin? ||
    user.role_accountant? || user.role_cto? ||
    user.role_site_manager?
  end

  def update?
    # Same group as create
    user.role_ceo? || user.role_admin? ||
    user.role_accountant? || user.role_cto? ||
    user.role_site_manager?
  end

  def destroy?
    # Restrict destructive actions to top roles
    user.role_ceo? || user.role_admin?
  end

  class Scope < Scope
    def resolve
      if user.role_ceo? || user.role_admin? || user.role_accountant? ||
         user.role_cto? || user.role_site_manager? || user.role_hr? || user.role_storekeeper?
        # Exec/management/finance roles see all expenses
        scope.all
      else
        # Engineers/QS only see expenses tied to projects they have tasks on
        scope.joins(project: { tasks: :assignments })
             .where(assignments: { user_id: user.id })
             .distinct
      end
    end
  end
end
