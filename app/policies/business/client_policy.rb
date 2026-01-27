class Business::ClientPolicy < ApplicationPolicy
  include ClientScopedPolicy # newly added

  def index?
    user.role_ceo? || user.role_cto? || user.role_admin? || user.role_hr? ||
    user.role_client? # newly added
  end

  def show?
    user.role_client? ? record.id == user.client&.id : index?
  end

  def create?
    user.role_ceo? || user.role_cto? || user.role_admin? || user.role_hr?
  end

  def update?
    user.role_ceo? || user.role_cto? || user.role_admin? || user.role_hr?
  end

  def destroy?
    user.role_ceo? || user.role_cto? || user.role_admin? || user.role_hr?
  end

  class Scope < Scope
    def resolve
      if user.role_client? && user.client.present? # newly added
        scope.where(id: user.client.id)
      elsif user.role_ceo? || user.role_cto? || user.role_admin? || user.role_hr?
        scope.all
      else
        scope.none
      end
    end
  end
end
