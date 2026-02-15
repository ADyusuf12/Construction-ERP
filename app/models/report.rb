class Report < ApplicationRecord
  belongs_to :project
  belongs_to :employee, class_name: "Hr::Employee"

  enum :report_type, { daily: 0, weekly: 1 }, prefix: true
  enum :status, { draft: 0, submitted: 1, reviewed: 2 }, prefix: true

  validates :report_date, presence: true
  validates :progress_summary, presence: true, length: { minimum: 10 }

  # Delegate name for easier access in views
  delegate :full_name, to: :employee, prefix: true, allow_nil: true
end
