class Report < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum :report_type, { daily: 0, weekly: 1 }, prefix: true
  enum :status, { draft: 0, submitted: 1, reviewed: 2 }, prefix: true

  validates :report_date, presence: true
  validates :progress_summary, presence: true, length: { minimum: 10 }

  scope :recent, -> { order(report_date: :desc) }
  scope :submitted, -> { where(status: statuses[:submitted]) }
  scope :reviewed, -> { where(status: statuses[:reviewed]) }
end
