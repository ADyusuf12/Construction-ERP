module Accounting
  class SalaryBatchPolicy < ApplicationPolicy
    # user = current_user, record = @salary_batch

    def index?
      user.role_ceo? || user.role_admin? ||
      user.role_accountant? || user.role_cto? || user.role_hr?
    end

    def show?
      index?
    end

    def create?
      user.role_ceo? || user.role_admin? ||
      user.role_accountant? || user.role_cto? ||
      user.role_hr?
    end

    def update?
      user.role_ceo? || user.role_admin? ||
      user.role_accountant? || user.role_cto? ||
      user.role_hr?
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
           user.role_cto? || user.role_site_manager? || user.role_hr?
          # Exec/finance/HR roles see all salary batches
          scope.all
        else
          # Other roles (QS, Engineer, Storekeeper) don’t interact with salary batches
          scope.none
        end
      end
    end
  end
end
