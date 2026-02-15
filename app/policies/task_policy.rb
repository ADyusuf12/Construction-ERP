class TaskPolicy < ApplicationPolicy
  include ClientScopedPolicy

  def index?
    user.role_ceo? || user.role_admin? || user.role_hr? ||
    user.role_cto? || user.role_site_manager? || user.role_qs? || user.role_engineer? ||
    user.role_client?
  end

  def show?
    user.role_client? ? record.project&.client_id == user.client&.id : index? || user.role_hr?
  end

  def create?
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
  end

  def update?
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
  end

  def destroy?
    user.role_ceo? || user.role_admin? || user.role_cto?  || user.role_hr?
  end

  def mark_in_progress?
    # REFACTORED: Allow the assigned personnel OR managers to update status
    assigned_to_task? || user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
  end

  def mark_done?
    assigned_to_task? || user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
  end

  class Scope < Scope
    def resolve
      if user.role_client? && user.client.present?
        scope.joins(:project).where(projects: { client_id: user.client.id })
      elsif user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
        scope.all
      else
        # REFACTORED: Filter by the current user's employee record
        scope.joins(:assignments).where(assignments: { employee_id: user.employee&.id }).distinct
      end
    end
  end

  private

  def assigned_to_task?
    return false unless user.employee
    record.assignments.exists?(employee_id: user.employee.id)
  end
end
