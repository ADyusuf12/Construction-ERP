module Accounting
  class DeductionPolicy < ApplicationPolicy
    # user = current_user, record = @deduction

    def index?
      user.role_ceo? || user.role_admin? ||
      user.role_accountant? || user.role_cto? ||
      user.role_site_manager? || user.role_hr?
    end

    def show?
      index?
    end

    def create?
      user.role_ceo? || user.role_admin? ||
      user.role_accountant? || user.role_cto? ||
      user.role_site_manager?
    end

    def update?
      user.role_ceo? || user.role_admin? ||
      user.role_accountant? || user.role_cto? ||
      user.role_site_manager?
    end

    def destroy?
      user.role_ceo? || user.role_admin? || user.role_accountant?
    end

    class Scope < Scope
      def resolve
        if user.role_ceo? || user.role_admin? || user.role_accountant? ||
           user.role_cto? || user.role_site_manager? || user.role_hr?
          # Exec/finance/HR roles see all deductions
          scope.all
        else
          # Other roles (QS, Engineer, Storekeeper) don’t interact with deductions
          scope.none
        end
      end
    end
  end
end
