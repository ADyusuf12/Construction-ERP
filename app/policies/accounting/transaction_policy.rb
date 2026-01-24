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
      user.role_ceo? || user.role_admin? || user.role_accountant? || user.role_cto? || user.role_hr?
    end

    def update?
      user.role_ceo? || user.role_admin? || user.role_accountant? || user.role_cto? || user.role_hr?
    end

    def destroy?
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    def mark_paid?
      user.role_ceo? || user.role_admin? || user.role_accountant? || user.role_hr?
    end

    class Scope < Scope
      def resolve
        if user.role_ceo? || user.role_admin? || user.role_accountant? ||
           user.role_cto? || user.role_hr?
          # Exec/management/finance roles see all transactions
          scope.all
        else
          scope.none
        end
      end
    end
  end
end
