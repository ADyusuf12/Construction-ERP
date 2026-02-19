module Accounting
  class SalaryBatchesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_salary_batch, only: %i[ show edit mark_paid ]

    def index
      authorize Accounting::SalaryBatch
      @salary_batches = policy_scope(Accounting::SalaryBatch).recent.page(params[:page]).per(10)
    end

    def show
      authorize @salary_batch
      # Optimized: includes(:employee, :deductions) prevents 100+ SQL queries on one page
      @salaries = @salary_batch.salaries.includes(:employee, :deductions).order("hr_personal_details.last_name ASC").references(:hr_personal_details)
    end

    def create
      @salary_batch = Accounting::SalaryBatch.new(batch_params)
      authorize @salary_batch

      if @salary_batch.save
        # Use the count from the association we just created
        count = @salary_batch.salaries.count
        redirect_to accounting_salary_batch_path(@salary_batch),
                    notice: "Batch successfully initialized. #{count} salary records generated."
      else
        render :new, status: :unprocessable_content
      end
    end

    def mark_paid
      authorize @salary_batch
      if @salary_batch.mark_all_salaries_paid!
        # Trigger background slip generation
        SalarySlipJob.perform_later(@salary_batch.id) if defined?(SalarySlipJob)

        redirect_to accounting_salary_batch_path(@salary_batch), notice: "Disbursement complete. All salaries marked as PAID."
      else
        redirect_to accounting_salary_batch_path(@salary_batch), alert: "Process failed. Check individual salary statuses."
      end
    end

    private

    def set_salary_batch
      @salary_batch = Accounting::SalaryBatch.find(params[:id])
    end

    def batch_params
      params.require(:accounting_salary_batch).permit(:name, :period_start, :period_end)
    end
  end
end
