module Business
  class Client < ApplicationRecord
    belongs_to :user, optional: true
    has_many :projects, dependent: :nullify

    validates :name, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  end
end
