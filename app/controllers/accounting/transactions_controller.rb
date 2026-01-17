module Accounting
  class TransactionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_transaction, only: %i[show edit update destroy mark_paid]

    def index
      @transactions = policy_scope(Accounting::Transaction.order(date: :desc))
      counts = Accounting::Transaction.summary_counts(policy_scope(Accounting::Transaction))
      @total_invoices = counts[:invoices]
      @total_receipts = counts[:receipts]
      @outsanding = counts[:outstanding]
    end

    def show
      authorize @transaction
    end

    def new
      @transaction = Accounting::Transaction.new(date: Date.current, status: :unpaid)
      authorize @transaction
    end

    def create
      @transaction = Accounting::Transaction.new(transaction_params)
      authorize @transaction
      if @transaction.save
        redirect_to accounting_transactions_path, notice: "Transaction recorded."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @transaction
    end

    def update
      authorize @transaction
      if @transaction.update(transaction_params)
        redirect_to accounting_transactions_path, notice: "Transaction updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @transaction
      @transaction.destroy
      redirect_to accounting_transactions_path, notice: "Transaction deleted."
    end

    def mark_paid
      authorize @transaction, :mark_paid?
      if @transaction.update(status: :paid)
        redirect_to accounting_transactions_path, notice: "Transaction marked as paid."
      else
        redirect_to accounting_transactions_path, alert: "Failed to mark transaction as paid."
      end
    end

    private

    def set_transaction
      @transaction = Accounting::Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:accounting_transaction).permit(
        :date, :description, :amount, :transaction_type, :status, :reference, :notes
      )
    end
  end
end
