module Accounting
  class Transaction < ApplicationRecord
    self.table_name = "transactions"

    enum :transaction_type, { invoice: 0, receipt: 1 }, prefix: true
    enum :status, { unpaid: 0, paid: 1 }, prefix: true

    validates :date, :description, :amount, :transaction_type, :status, presence: true
    validates :amount, numericality: { greater_than: 0 }

    scope :invoice,  -> { where(transaction_type: :invoice) }
    scope :receipt,  -> { where(transaction_type: :receipt) }
    scope :unpaid,   -> { where(status: :unpaid) }
    scope :paid,     -> { where(status: :paid) }

    # --- Global transaction summaries ---
    def self.invoice_count(scope = all)
      scope.invoice.count
    end

    def self.receipt_count(scope = all)
      scope.receipt.count
    end

    def self.outstanding(scope = all)
      scope.invoice.unpaid.count
    end

    def self.summary_counts(scope = all)
      {
        invoices: invoice_count(scope),
        receipts: receipt_count(scope),
        outstanding: outstanding(scope)
      }
    end
  end
end
