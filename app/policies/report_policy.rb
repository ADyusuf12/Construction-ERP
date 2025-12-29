class ReportPolicy < ApplicationPolicy
  def index?
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_manager? || user.role_hr? || user.role_accountant? ||
    project_member?
  end

  def show?
    index?
  end

  def create?
    project_member? || user.role_ceo? || user.role_admin? || user.role_cto? || user.role_manager?
  end

  def update?
    record.user_id == user.id && record.status_draft?
  end

  def destroy?
    user.role_ceo? || user.role_admin? || user.role_cto?
  end

  def submit?
    record.user_id == user.id && record.status_draft?
  end

  def review?
    (user.role_manager? || user.role_cto? || user.role_ceo?) && record.status_submitted?
  end

  class Scope < Scope
    def resolve
      if user.role_ceo? || user.role_admin? || user.role_cto? || user.role_manager? || user.role_hr? || user.role_accountant?
        scope.all
      else
        scope.joins(project: { tasks: :assignments }).where(assignments: { user_id: user.id })
      end
    end
  end

  private

  def project_member?
    return false unless record.project
    record.project.tasks.joins(:assignments).exists?(assignments: { user_id: user.id })
  end
end
