class TaskPolicy < ApplicationPolicy
  include ClientScopedPolicy # newly added

  def index?
    user.role_ceo? || user.role_admin? || user.role_hr? ||
    user.role_cto? || user.role_site_manager? || user.role_qs? || user.role_engineer? ||
    user.role_client? # newly added
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
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
  end

  def mark_done?
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
  end

  class Scope < Scope
    def resolve
      if user.role_client? && user.client.present? # newly added
        scope.joins(:project).where(projects: { client_id: user.client.id })
      elsif user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
        scope.all
      else
        scope.joins(:assignments).where(assignments: { user_id: user.id }).distinct
      end
    end
  end
end
