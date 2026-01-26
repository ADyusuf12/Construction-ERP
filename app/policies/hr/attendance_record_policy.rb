module Hr
  class AttendanceRecordPolicy < ApplicationPolicy
    # Top-level checks
    def index?
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    def my_attendance?
      user.employee.present?
    end

    def show?
      return true if index? # HR/Admin/CEO can view any record

      # Managers can view their subordinates' records
      if user.employee.present? && user.employee.subordinates.exists?(id: record.employee_id)
        return true
      end

      # Regular employees can view their own record
      record.employee.user_id == user.id
    end

    def create?
      # Any user linked to an employee can create their own attendance record.
      # HR/Admin/CEO can create for anyone via UI.
      user.employee.present?
    end

    def update?
      # HR/Admin/CEO can update any record
      return true if index?

      # Managers can update subordinates
      if user.employee.present? && user.employee.subordinates.exists?(id: record.employee_id)
        return true
      end

      # Employees can update their own record
      record.employee.user_id == user.id
    end

    def destroy?
      # Only HR/Admin/CEO can destroy records
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    class Scope < Scope
      def resolve
        return scope.all if user.role_hr? || user.role_ceo? || user.role_admin?

        if user.employee.present?
          # Manager: see subordinates + self
          subordinate_ids = user.employee.subordinates.pluck(:id)
          scope.where(employee_id: subordinate_ids + [ user.employee.id ])
        else
          scope.none
        end
      end
    end
  end
end
