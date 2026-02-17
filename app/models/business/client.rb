module Business
  class Client < ApplicationRecord
    belongs_to :user, optional: true
    has_many :projects, dependent: :nullify

    validates :name, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

    validate :user_role_and_email_valid, if: -> { user.present? }

    private

    def user_role_and_email_valid
      unless user.role_client?
        errors.add(:user, "must have client role")
      end
    end
  end
end
