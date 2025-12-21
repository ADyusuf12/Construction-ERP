class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[show edit update destroy mark_paid]

  # GET /transactions
  def index
    @transactions = policy_scope(Transaction.includes(:project).order(date: :desc))

    counts = Transaction.summary_counts(policy_scope(Transaction))

    @total_invoices = counts[:invoices]
    @total_receipts = counts[:receipts]
    @outsanding = counts[:outstanding]
  end

  # GET /transactions/:id
  def show
    authorize @transaction
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new(date: Date.current, status: :unpaid)
    authorize @transaction
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)
    authorize @transaction

    if @transaction.save
      redirect_to transactions_path, notice: "Transaction recorded."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /transactions/:id/edit
  def edit
    authorize @transaction
  end

  # PATCH/PUT /transactions/:id
  def update
    authorize @transaction
    if @transaction.update(transaction_params)
      redirect_to transactions_path, notice: "Transaction updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/:id
  def destroy
    authorize @transaction
    @transaction.destroy
    redirect_to transactions_path, notice: "Transaction deleted."
  end

  # PATCH /transactions/:id/mark_paid
  def mark_paid
    authorize @transaction, :mark_paid?
    if @transaction.update(status: :paid)
      redirect_to transactions_path, notice: "Transaction marked as paid."
    else
      redirect_to transactions_path, alert: "Failed to mark transaction as paid."
    end
  end

  private

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(
        :project_id, :date, :description, :amount, :transaction_type, :status, :reference, :notes
      )
    end
end
