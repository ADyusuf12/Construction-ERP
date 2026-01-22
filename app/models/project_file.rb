class ProjectFile < ApplicationRecord
  belongs_to :project
  has_one_attached :file

  validates :file, presence: true
  validates :title, presence: true, length: { maximum: 150 }
  validates :description, length: { maximum: 500 }, allow_blank: true

  scope :recent, -> { order(created_at: :desc) }
  scope :with_title, ->(query) { where("title ILIKE ?", "%#{query}%") }
end
