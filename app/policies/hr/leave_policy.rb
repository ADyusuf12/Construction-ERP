module Hr
  class LeavePolicy < ApplicationPolicy
    def index?
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    def my_leaves?
      user.employee.present?
    end

    def show?
      if user.role_engineer? || user.role_qs? || user.role_storekeeper? || user.role_accountant?
        record.employee_id == user.employee&.id
      else
        index?
      end
    end

    def create?
      user.employee.present?
    end

    def approve?
      (user.role_hr? || user.role_ceo? || user.role_admin?) &&
        record.employee_id != user.employee&.id
    end

    def reject?
      approve?
    end

    def cancel?
      record.employee_id == user.employee&.id
    end

    def dashboard?
      user.employee.present?
    end

    class Scope < Scope
      def resolve
        if user.role_hr? || user.role_ceo? || user.role_admin?
          scope.all
        else
          scope.none
        end
      end
    end
  end
end
