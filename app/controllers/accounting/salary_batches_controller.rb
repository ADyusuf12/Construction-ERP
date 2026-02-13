module Accounting
  class SalaryBatchesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_salary_batch, only: %i[ show edit update destroy mark_paid ]

    # GET /accounting/salary_batches
    def index
      authorize Accounting::SalaryBatch
      @salary_batches = policy_scope(Accounting::SalaryBatch)

      per_page = params.fetch(:per_page, 10).to_i
      @salary_batches = @salary_batches.page(params[:page]).per(per_page)
    end

    # GET /accounting/salary_batches/:id
    def show
      authorize @salary_batch
    end

    # GET /accounting/salary_batches/new
    def new
      @salary_batch = Accounting::SalaryBatch.new
      authorize @salary_batch
    end

    # GET /accounting/salary_batches/:id/edit
    def edit
      authorize @salary_batch
    end

    # POST /accounting/salary_batches
    def create
      @salary_batch = Accounting::SalaryBatch.new(batch_params)
      authorize @salary_batch

      if @salary_batch.save
        redirect_to accounting_salary_batches_path, notice: "Salary batch was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    # PATCH/PUT /accounting/salary_batches/:id
    def update
      authorize @salary_batch
      if @salary_batch.update(batch_params)
        redirect_to accounting_salary_batches_path, notice: "Salary batch was successfully updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    # DELETE /accounting/salary_batches/:id
    def destroy
      authorize @salary_batch
      @salary_batch.destroy
      redirect_to accounting_salary_batches_path, notice: "Salary batch was successfully deleted."
    end

    # PATCH /accounting/salary_batches/:id/mark_paid
    def mark_paid
      authorize @salary_batch
      @salary_batch.transaction do
        @salary_batch.update!(status: :paid)
        @salary_batch.mark_all_salaries_paid!
        SalarySlipJob.perform_later(@salary_batch.id)
      end

      respond_to do |format|
        format.html { redirect_to accounting_salary_batches_path, notice: "Batch marked as paid." }
        format.turbo_stream
      end
    end

    private

      def set_salary_batch
        @salary_batch = Accounting::SalaryBatch.find(params[:id])
      end

      def batch_params
        params.require(:accounting_salary_batch).permit(
          :name, :period_start, :period_end, :status
        )
      end
  end
end
