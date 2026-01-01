module Accounting
  class TransactionPolicy < ApplicationPolicy
    # user = current_user, record = @transaction

    def index?
      user.role_ceo? || user.role_admin? ||
      user.role_accountant? || user.role_cto? || user.role_site_manager? ||
      user.role_qs? || user.role_engineer? || user.role_storekeeper? || user.role_hr?
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
        if user.role_ceo? || user.role_admin? || user.role_accountant? || user.role_cto? || user.role_site_manager? || user.role_hr? || user.role_storekeeper?
          scope.all
        else
          scope.joins(project: :assignments).where(assignments: { user_id: user.id })
        end
      end
    end
  end
end
