class ReportPolicy < ApplicationPolicy
  include ClientScopedPolicy

  def index?
    # Keeping your existing role-based access
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? ||
    user.role_hr? || user.role_accountant? || project_member? ||
    user.role_client?
  end

  def show?
    user.role_client? ? record.project&.client_id == user.client&.id : index?
  end

  def create?
    project_member? || user.role_ceo? || user.role_admin? || user.role_cto? ||
    user.role_site_manager? || user.role_hr?
  end

  def update?
    # REFACTORED: Check if the user is the owner of the employee who filed the report
    record.employee_id == user.employee&.id && record.status_draft?
  end

  def destroy?
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_hr?
  end

  def submit?
    # REFACTORED: Check if the user is the owner of the employee who filed the report
    record.employee_id == user.employee&.id && record.status_draft?
  end

  def review?
    (user.role_site_manager? || user.role_cto? || user.role_ceo? || user.role_admin? || user.role_hr?) &&
    record.status_submitted?
  end

  class Scope < Scope
    def resolve
      if user.role_client? && user.client.present?
        scope.joins(:project).where(projects: { client_id: user.client.id })
      elsif user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? ||
            user.role_hr? || user.role_accountant?
        scope.all
      else
        # REFACTORED: Link through tasks -> assignments -> employee
        scope.joins(project: { tasks: { assignments: :employee } })
             .where(assignments: { employee_id: user.employee&.id })
             .distinct
      end
    end
  end

  private

  def project_member?
    return false unless record.project && user.employee
    # REFACTORED: Check if the user's employee record is assigned to any task in the project
    record.project.tasks.joins(:assignments).exists?(assignments: { employee_id: user.employee.id })
  end
end
