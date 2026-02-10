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
      return false unless user

      return true if user.role_ceo? || user.role_admin? || user.role_site_manager? || user.role_storekeeper? || user.role_hr?
      return true if user.role_engineer? && movement_for_user_project?

      false
    end

    def update?
      return false unless user
      user.role_ceo? || user.role_admin? || user.role_site_manager? || user.role_storekeeper? || user.role_hr?
    end

    def destroy?
      return false unless user
      user.role_ceo? || user.role_admin? || user.role_storekeeper? || user.role_hr?
    end

    # NEW: reverse? — who can perform reversal
    # Mirrors destroy? privileges, since reversal is equally sensitive
    def reverse?
      return false unless user
      user.role_ceo? || user.role_admin? || user.role_storekeeper? || user.role_hr?
    end

    private

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
        return scope.none unless user

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
