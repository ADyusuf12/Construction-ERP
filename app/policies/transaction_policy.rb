class TransactionPolicy < ApplicationPolicy
  # user = current_user, record = @transaction

  def index?
    # CEO/Admin see everything
    user.role_ceo? || user.role_admin? ||
    # Accountant, CTO, Manager can view all transactions
    user.role_accountant? || user.role_cto? || user.role_site_manager? ||
    # QS/Engineer/Storekeeper/HR can view only their project’s transactions
    user.role_qs? || user.role_engineer? || user.role_storekeeper? || user.role_hr?
  end

  def show?
    index?
  end

  def create?
    # CEO/Admin/Accountant/CTO/Site Manager can create transactions
    user.role_ceo? || user.role_admin? || user.role_accountant? || user.role_cto? || user.role_site_manager?
  end

  def update?
    # CEO/Admin/Accountant/CTO/Manager can update transactions
    user.role_ceo? || user.role_admin? || user.role_accountant? || user.role_cto? || user.role_site_manager?
  end

  def destroy?
    # CEO/Admin can destroy, optionally Accountant/CTO if you want
    user.role_ceo? || user.role_admin?
  end

  def mark_paid?
    # CEO/Admin/Accountant can mark transactions as paid
    user.role_ceo? || user.role_admin? || user.role_accountant?
  end

  class Scope < Scope
    def resolve
      if user.role_ceo? || user.role_admin? || user.role_accountant? || user.role_cto? || user.role_site_manager? || user.role_hr? || user.role_storekeeper?
        scope.all
      else
        # QS, Engineer, Storekeeper, HR only see transactions tied to projects they’re assigned to
        scope.joins(project: :assignments).where(assignments: { user_id: user.id })
      end
    end
  end
end
