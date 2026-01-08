module Accounting
  class Transaction < ApplicationRecord
    self.table_name = "transactions"
    before_validation :normalize_amount

    belongs_to :project

    enum :transaction_type, { invoice: 0, receipt: 1 }, prefix: true
    enum :status, { unpaid: 0, paid: 1 }, prefix: true

    validates :date, :description, :amount, :transaction_type, :status, presence: true
    validates :amount, numericality: { greater_than: 0 }

    scope :invoice,  -> { where(transaction_type: :invoice) }
    scope :receipt,  -> { where(transaction_type: :receipt) }
    scope :unpaid,   -> { where(status: :unpaid) }
    scope :paid,     -> { where(status: :paid) }

    def self.summary_counts(scope = all)
      {
        invoices: scope.invoice.count,
        receipts: scope.receipt.count,
        outstanding: scope.invoice.unpaid.count
      }
    end

    private

    def normalize_amount
      self.amount = amount.to_d.round(2) if amount.present?
    end
  end
end
