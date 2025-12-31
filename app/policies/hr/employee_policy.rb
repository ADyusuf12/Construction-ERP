module Hr
  class EmployeePolicy < ApplicationPolicy
    # user = current_user, record = @employee

    def index?
      # CEO, Admin, CTO, HR, Manager can list employees
      user.role_ceo? || user.role_admin? || user.role_cto? || user.role_hr? || user.role_site_manager?
    end

    def show?
      if user.role_engineer? || user.role_qs? || user.role_storekeeper? || user.role_accountant?
        # limited roles can only view their own record
        record.user_id == user.id
      else
        # administrative roles can view any record
        index?
      end
    end

    def create?
      # CEO, Admin, HR can create employee records
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    def update?
      # CEO, Admin, HR can update employee records
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    def destroy?
      # CEO and Admin have destructive power, HR optionally
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    class Scope < Scope
      def resolve
        if user.role_ceo? || user.role_admin? || user.role_cto? || user.role_hr? || user.role_site_manager?
          scope.all
        else
          # non‑administrative roles only see their own employee record
          scope.where(user_id: user.id)
        end
      end
    end
  end
end
