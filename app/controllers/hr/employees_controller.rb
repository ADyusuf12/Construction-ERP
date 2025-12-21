module Hr
  class EmployeesController < ApplicationController
    before_action :set_employee, only: %i[ show edit update destroy ]

    # GET /hr/employees
    def index
      @employees = Hr::Employee.all
    end

    # GET /hr/employees/:id
    def show
    end

    # GET /hr/employees/new
    def new
      @employee = Hr::Employee.new
    end

    # GET /hr/employees/:id/edit
    def edit
    end

    # POST /hr/employees
    def create
      @employee = Hr::Employee.new(employee_params)

      if @employee.save
        redirect_to hr_employees_path, notice: "Employee was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    # PATCH/PUT /hr/employees/:id
    def update
      if @employee.update(employee_params)
        redirect_to hr_employees_path, notice: "Employee was successfully updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    # DELETE /hr/employees/:id
    def destroy
      @employee.destroy
      redirect_to hr_employees_path, notice: "Employee was successfully deleted."
    end

    private

      def set_employee
        @employee = Hr::Employee.find(params[:id])
      end

      def employee_params
        params.require(:hr_employee).permit(
          :department, :position_title, :hire_date,
          :status, :leave_balance, :performance_score
        )
      end
  end
end
