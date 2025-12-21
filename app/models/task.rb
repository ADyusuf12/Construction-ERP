class Task < ApplicationRecord
  belongs_to :project
  has_many :assignments, dependent: :destroy
  has_many :users, through: :assignments

  enum :status, { pending: 0, in_progress: 1, done: 2 }, prefix: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :weight, numericality: { greater_than: 0 }
end
