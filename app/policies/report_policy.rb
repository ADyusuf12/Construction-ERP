class ReportPolicy < ApplicationPolicy
  include ClientScopedPolicy # newly added

  def index?
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? ||
    user.role_hr? || user.role_accountant? || project_member? ||
    user.role_client? # newly added
  end

  def show?
    user.role_client? ? record.project&.client_id == user.client&.id : index?
  end

  def create?
    project_member? || user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
  end

  def update?
    record.user_id == user.id && record.status_draft?
  end

  def destroy?
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_hr?
  end

  def submit?
    record.user_id == user.id && record.status_draft?
  end

  def review?
    (user.role_site_manager? || user.role_cto? || user.role_ceo? || user.role_admin? || user.role_hr?) &&
    record.status_submitted?
  end

  class Scope < Scope
    def resolve
      if user.role_client? && user.client.present? # newly added
        scope.joins(:project).where(projects: { client_id: user.client.id })
      elsif user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? ||
            user.role_hr? || user.role_accountant?
        scope.all
      else
        scope.joins(project: { tasks: :assignments })
             .where(assignments: { user_id: user.id })
             .distinct
      end
    end
  end

  private

  def project_member?
    return false unless record.project
    record.project.tasks.joins(:assignments).exists?(assignments: { user_id: user.id })
  end
end
