module Accounting
  class SalaryBatch < ApplicationRecord
    has_many :salaries, class_name: "Accounting::Salary", foreign_key: "batch_id", dependent: :destroy

    validates :name, presence: true
    validates :period_start, presence: true
    validates :period_end, presence: true

    enum :status, { pending: 0, processed: 1, paid: 2 }, prefix: true

    scope :recent, -> { order(period_start: :desc) }

    def period_label
      "#{period_start.strftime("%B %Y")}"
    end

    def total_net_pay
      salaries.sum(:net_pay)
    end

    def mark_all_salaries_paid!
      salaries.update_all(status: :paid)
    end
  end
end
