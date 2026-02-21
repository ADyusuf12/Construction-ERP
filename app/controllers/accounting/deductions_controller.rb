module Accounting
  class DeductionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_deduction, only: %i[ show edit update destroy ]

    def index
      authorize Accounting::Deduction
      @deductions = policy_scope(Accounting::Deduction).includes(salary: [:employee, :batch])
    end

    def show
      authorize @deduction
    end

    def new
      @deduction = Accounting::Deduction.new(salary_id: params[:salary_id])
      authorize @deduction
    end

    def edit
      authorize @deduction
    end

    def create
      @deduction = Accounting::Deduction.new(deduction_params)
      authorize @deduction

      if @deduction.save
        # Redirect back to the Batch Show page to see the recalculated Net Pay
        redirect_to accounting_salary_batch_path(@deduction.salary.batch),
                    notice: "Deduction added for #{@deduction.salary.employee.full_name}. Net pay updated."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      authorize @deduction
      if @deduction.update(deduction_params)
        redirect_to accounting_salary_batch_path(@deduction.salary.batch),
                    notice: "Deduction updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      authorize @deduction
      batch = @deduction.salary.batch # Capture batch before destroying
      @deduction.destroy

      redirect_to accounting_salary_batch_path(batch),
                  notice: "Deduction removed. Net pay restored."
    end

    private

    def set_deduction
      @deduction = Accounting::Deduction.find(params[:id])
    end

    def deduction_params
      params.require(:accounting_deduction).permit(
        :salary_id, :deduction_type, :amount, :notes
      )
    end
  end
end
