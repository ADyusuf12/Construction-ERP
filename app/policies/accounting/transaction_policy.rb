module Accounting
  class TransactionPolicy < ApplicationPolicy
    # user = current_user, record = @transaction

    def index?
      user.role_ceo? || user.role_admin? ||
      user.role_accountant? || user.role_cto? || user.role_site_manager? || user.role_engineer? || user.role_storekeeper? || user.role_hr?
    end

    def show?
      index?
    end

    def create?
      user.role_ceo? || user.role_admin? || user.role_accountant? || user.role_cto? || user.role_site_manager?
    end

    def update?
      user.role_ceo? || user.role_admin? || user.role_accountant? || user.role_cto? || user.role_site_manager?
    end

    def destroy?
      user.role_ceo? || user.role_admin?
    end

    def mark_paid?
      user.role_ceo? || user.role_admin? || user.role_accountant?
    end

    class Scope < Scope
      def resolve
        if user.role_ceo? || user.role_admin? || user.role_accountant? ||
           user.role_cto? || user.role_site_manager? || user.role_hr? || user.role_storekeeper?
          # Exec/management/finance roles see all transactions
          scope.all
        else
          # Engineers/QS only see transactions tied to projects they have tasks on
          scope.joins(project: { tasks: :assignments })
               .where(assignments: { user_id: user.id })
               .distinct
        end
      end
    end
  end
end
