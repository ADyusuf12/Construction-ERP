module Inventory
  class WarehousePolicy < ApplicationPolicy
    def index?
      user.role_ceo? || user.role_admin? || user.role_cto? ||
      user.role_site_manager? || user.role_storekeeper? || user.role_hr? || user.role_accountant?
    end

    def show?
      index?
    end

    # Creation and updates are operational responsibilities:
    # Admins and site teams (site managers, storekeepers) can create/update warehouses.
    def create?
      user.role_ceo? || user.role_admin? || user.role_site_manager? || user.role_storekeeper?
    end

    def update?
      user.role_ceo? || user.role_admin? || user.role_site_manager? || user.role_storekeeper?
    end

    # Destructive actions are restricted to executive roles only
    def destroy?
      user.role_ceo? || user.role_admin?
    end

    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
end
