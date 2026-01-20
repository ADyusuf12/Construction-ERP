module Hr
  class PersonalDetailPolicy < ApplicationPolicy
    # user = current_user, record = @personal_detail

    def index?
      user.role_ceo? || user.role_admin? ||
      user.role_hr? || user.role_cto? ||
      user.role_site_manager?
    end

    def show?
      user.role_ceo? || user.role_admin? ||
      user.role_hr? || user.role_cto? ||
      user.role_site_manager? ||
      record.employee.user_id == user.id
    end

    def create?
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    def update?
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    def destroy?
      user.role_ceo? || user.role_admin? || user.role_hr?
    end

    class Scope < Scope
      def resolve
        if user.role_ceo? || user.role_admin? || user.role_hr? ||
           user.role_cto? || user.role_site_manager?
          # Exec/HR/management roles see all personal details
          scope.all
        else
          # Employees only see their own personal detail record
          scope.where(employee_id: user.employee&.id)
        end
      end
    end
  end
end
