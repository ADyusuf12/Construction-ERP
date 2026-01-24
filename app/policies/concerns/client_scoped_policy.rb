# app/policies/concerns/client_scoped_policy.rb
module ClientScopedPolicy
  extend ActiveSupport::Concern

  included do
    # Scope override for client role users
    class Scope < ApplicationPolicy::Scope
      def resolve
        if user.role_client? && user.client.present?
          scope.joins(:project).where(projects: { client_id: user.client.id })
        else
          super
        end
      end
    end
  end

  # Common show? logic for client role
  def show?
    if user.role_client?
      record.respond_to?(:project) &&
        record.project&.client_id == user.client&.id
    else
      super
    end
  end

  # Common index? logic for client role
  def index?
    if user.role_client?
      true # they can list, but scope limits them
    else
      super
    end
  end
end
