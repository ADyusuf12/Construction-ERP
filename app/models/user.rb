class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { ceo: 0, cto: 1, qs: 2, manager: 3, engineer: 4, storekeeper: 5, hr: 6, accountant: 7, admin: 8 }, prefix: true

  has_one :employee, class_name: "Hr::Employee", dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :tasks, through: :assignments
  has_many :transactions, dependent: :destroy
  has_many :reports, dependent: :destroy
end
