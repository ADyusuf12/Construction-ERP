module Accounting
  class SalariesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_salary, only: %i[ show edit update destroy ]

    # GET /accounting/salaries
    def index
      authorize Accounting::Salary
      @salaries = policy_scope(Accounting::Salary)
    end

    # GET /accounting/salaries/:id
    def show
      authorize @salary
    end

    # GET /accounting/salaries/new
    def new
      @salary = Accounting::Salary.new
      authorize @salary
    end

    # GET /accounting/salaries/:id/edit
    def edit
      authorize @salary
    end

    # POST /accounting/salaries
    def create
      @salary = Accounting::Salary.new(salary_params)
      authorize @salary

      if @salary.save
        redirect_to accounting_salaries_path, notice: "Salary was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    # PATCH/PUT /accounting/salaries/:id
    def update
      authorize @salary
      if @salary.update(salary_params)
        redirect_to accounting_salaries_path, notice: "Salary was successfully updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    # DELETE /accounting/salaries/:id
    def destroy
      authorize @salary
      @salary.destroy
      redirect_to accounting_salaries_path, notice: "Salary was successfully deleted."
    end

    private

      def set_salary
        @salary = Accounting::Salary.find(params[:id])
      end

      def salary_params
        params.require(:accounting_salary).permit(
          :employee_id, :batch_id, :base_pay, :allowances,
          :deductions_total, :net_pay, :status
        )
      end
  end
end
