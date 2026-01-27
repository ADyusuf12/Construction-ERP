class ProjectPolicy < ApplicationPolicy
  include ClientScopedPolicy # newly added

  def index?
    if user.role_client?
      true # they can see their own projects via scope
    else
      user.role_ceo? || user.role_admin? ||
      user.role_cto? || user.role_site_manager? || user.role_qs? ||
      user.role_engineer? || user.role_storekeeper? || user.role_hr?
    end
  end

  def show?
    user.role_client? ? record.client_id == user.client&.id : index?
  end

  def create?
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
  end

  def update?
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_site_manager? || user.role_hr?
  end

  def destroy?
    user.role_ceo? || user.role_admin? || user.role_cto? || user.role_hr?
  end

  class Scope < Scope
    def resolve
      if user.role_client? && user.client.present? # newly added
        scope.where(client_id: user.client.id)
      elsif user.role_engineer? || user.role_qs?
        scope.joins(tasks: :assignments)
             .where(assignments: { user_id: user.id })
             .distinct
      else
        scope.all
      end
    end
  end
end
