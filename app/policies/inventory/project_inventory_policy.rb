module Inventory
  class ProjectInventoryPolicy < ApplicationPolicy
    def create?
      return true if user.role_admin? || user.role_ceo? || user.role_site_manager? || user.role_storekeeper?
      return true if user.role_engineer? && user_belongs_to_project?
      false
    end

    def update?
      create?
    end

    def destroy?
      user.role_admin? || user.role_ceo? || user.role_storekeeper? || user_belongs_to_project?
    end

    private

    # Returns true when the current user is assigned to the project for this record.
    # Works for both persisted records and new records (guards for missing associations).
    def user_belongs_to_project?
      project_id = record.try(:project_id) || (record.respond_to?(:project) && record.project&.id)
      return false unless project_id.present?

      Project.joins(tasks: :assignments)
             .where(id: project_id, assignments: { user_id: user.id })
             .exists?
    end

    class Scope < Scope
      def resolve
        if user.role_engineer? || user.role_qs?
          project_ids = Project.joins(tasks: :assignments)
                               .where(assignments: { user_id: user.id })
                               .distinct
                               .pluck(:id)
          scope.where(project_id: project_ids)
        else
          scope.all
        end
      end
    end
  end
end
