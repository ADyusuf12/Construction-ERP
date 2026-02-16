module Hr
  class LeavePolicy < ApplicationPolicy
    def index?
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    def my_leaves?
      user.employee.present?
    end

    def show?
      return true if index?
      record.employee_id == user.employee&.id
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

    def destroy?
      # An employee can delete their own request IF it hasn't been acted upon yet
      own_record = record.employee_id == user.employee&.id
      is_pending = record.status_pending?

      # HR/Admin can delete any pending request
      can_manage = user.role_hr? || user.role_ceo? || user.role_admin?

      is_pending && (own_record || can_manage)
    end

    def edit?
      # Only allow editing if it's still pending
      record.status_pending? && (record.employee_id == user.employee&.id || approve?)
    end

    def dashboard?
      user.employee.present?
    end

    class Scope < Scope
      def resolve
        if user.role_hr? || user.role_ceo? || user.role_admin?
          scope.all
        elsif user.employee.present?
          scope.where(employee_id: user.employee.id)
        else
          scope.none
        end
      end
    end
  end
end
