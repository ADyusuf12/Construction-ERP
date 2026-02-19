module Accounting
  class SalariesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_salary, only: %i[show edit update]

    def index
      authorize Accounting::Salary

      per_page = params.fetch(:per_page, 15).to_i

      base_scope = policy_scope(Accounting::Salary).includes(:batch, :employee)

      @salary_stats = base_scope

      @salaries = policy_scope(Accounting::Salary)
                  .includes(:employee, :batch)
                  .joins(:batch)
                  .order("accounting_salary_batches.period_start DESC")
                  .page(params[:page])
                  .per(per_page)
    end

    def update
      authorize @salary
      if @salary.update(salary_params)
        # Standard ERP workflow: return to the batch context
        redirect_to accounting_salary_batch_path(@salary.batch),
                    notice: "Compensation record for #{@salary.employee.full_name} updated successfully."
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def set_salary
      @salary = Accounting::Salary.find(params[:id])
    end

    def salary_params
      # Model logic (before_validation) calculates net_pay; UI only inputs variables.
      params.require(:accounting_salary).permit(:base_pay, :allowances)
    end
  end
end
