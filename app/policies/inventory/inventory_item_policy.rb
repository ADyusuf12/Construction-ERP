module Inventory
  class InventoryItemPolicy < ApplicationPolicy
    def index?
      user.role_ceo? || user.role_admin? ||
      user.role_site_manager? || user.role_qs? || user.role_engineer? ||
      user.role_storekeeper? || user.role_hr? || user.role_accountant?
    end

    def show?
      index?
    end

    def create?
      user.role_ceo? || user.role_admin? || user.role_site_manager? || user.role_storekeeper? || user.role_hr?
    end

    def update?
      user.role_ceo? || user.role_admin? || user.role_site_manager? || user.role_storekeeper? || user.role_hr?
    end

    def destroy?
      user.role_ceo? || user.role_admin? || user.role_storekeeper? || user.role_hr?
    end

    class Scope < Scope
      def resolve
        if user.role_engineer? || user.role_qs?
          project_ids = Project.joins(tasks: :assignments)
                                .where(assignments: { employee_id: user.employee&.id })
                                .distinct
                                .pluck(:id)
          scope.joins(:project_inventories)
               .where(project_inventories: { project_id: project_ids })
               .group("inventory_items.id")
        else
          scope.all
        end
      end
    end
  end
end
