class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, {
    ceo: 0, cto: 1, qs: 2, site_manager: 3, engineer: 4,
    storekeeper: 5, hr: 6, accountant: 7, admin: 8, client: 9
  }, prefix: true

  has_one :employee, class_name: "Hr::Employee", dependent: :destroy
  delegate :tasks, :reports, :leaves, to: :employee, allow_nil: true
  has_one :client, class_name: "Business::Client", dependent: :destroy
  has_many :projects, dependent: :destroy

  # Validations
  validate :staff_users_must_have_employee
  validate :client_users_must_have_client

  def full_name
    if role_admin?
      "Admin User ##{id}"
    elsif employee.present?
      employee.full_name
    else
      "User ##{id}"
    end
  end

  private

  def staff_users_must_have_employee
    staff_roles = %w[ceo cto qs site_manager engineer storekeeper hr accountant admin]

    return if new_record?

    if role.in?(staff_roles) && employee.nil?
      errors.add(:employee, "must be linked for staff users")
    end
  end

  def client_users_must_have_client
    # We skip this check on the very first save
    return if new_record?

    if role == "client" && client.nil?
      errors.add(:client, "must be linked for client users")
    end
  end
end
