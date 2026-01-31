# app/policies/inventory/stock_movement_policy.rb
module Inventory
  class StockMovementPolicy < ApplicationPolicy
    def index?
      return false unless user
      user.role_ceo? || user.role_admin? || user.role_site_manager? || user.role_storekeeper? || user.role_hr?
    end

    def show?
      return false unless user
      user.role_ceo? || user.role_admin? || user.role_site_manager? || user.role_storekeeper? || user.role_hr?
    end

    def create?
      # nil users cannot act
      return false unless user

      # Match InventoryItemPolicy#create? privileges
      return true if user.role_ceo? || user.role_admin? || user.role_site_manager? || user.role_storekeeper? || user.role_hr?

      # Engineers may create movements only for items tied to projects they belong to
      return true if user.role_engineer? && movement_for_user_project?

      # All others denied
      false
    end

    def update?
      return false unless user

      # Match InventoryItemPolicy#update? privileges
      user.role_ceo? || user.role_admin? || user.role_site_manager? || user.role_storekeeper? || user.role_hr?
    end

    def destroy?
      return false unless user

      # Match InventoryItemPolicy#destroy? privileges
      user.role_ceo? || user.role_admin? || user.role_storekeeper? || user.role_hr?
    end

    private

    # Returns true when the movement's inventory_item is linked to a project
    # the user is assigned to (via tasks -> assignments). Guards for nil/new records.
    def movement_for_user_project?
      return false unless user
      return false unless record.respond_to?(:inventory_item)

      item = record.inventory_item
      return false unless item.present?

      project_ids = Project.joins(tasks: :assignments)
                           .where(assignments: { user_id: user.id })
                           .distinct
                           .pluck(:id)

      (item.projects.pluck(:id) & project_ids).any?
    end

    class Scope < Scope
      def resolve
        # nil user gets no results
        return scope.none unless user

        # Engineers and QS see only movements tied to their projects (same pattern as InventoryItemPolicy)
        if user.role_engineer? || user.role_qs?
          project_ids = Project.joins(tasks: :assignments)
                               .where(assignments: { user_id: user.id })
                               .distinct
                               .pluck(:id)

          scope.joins(inventory_item: :project_inventories)
               .where(project_inventories: { project_id: project_ids })
               .distinct
        else
          scope.all
        end
      end
    end
  end
end
