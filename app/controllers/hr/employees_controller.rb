module Hr
  class EmployeesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_employee, only: %i[ show edit update destroy ]
    before_action :load_form_collections, only: %i[new edit create update]

    def index
      authorize Hr::Employee
      @employees = policy_scope(Hr::Employee)
      if params[:q].present?
        @employees = @employees.where("staff_id ILIKE ?", "%#{params[:q]}%")
      end
    end

    def show
      authorize @employee
      # Preload adjustments for the show page
      @recurring_adjustments = @employee.recurring_adjustments.order(adjustment_type: :asc)
    end

    def new
      @employee = Hr::Employee.new
      @employee.build_personal_detail
      @employee.next_of_kins.build
      @employee.recurring_adjustments.build
      authorize @employee
    end

    def edit
      authorize @employee
      @employee.build_personal_detail if @employee.personal_detail.nil?
    end

    def create
      @employee = Hr::Employee.new(employee_params)
      authorize @employee

      if @employee.save
        redirect_to hr_employee_path(@employee), notice: "Employee was successfully created."
      else
        load_form_collections
        render :new, status: :unprocessable_content
      end
    end

    def update
      authorize @employee
      if @employee.update(employee_params)
        redirect_to hr_employee_path(@employee), notice: "Employee updated."
      else
        load_form_collections
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      authorize @employee
      @employee.destroy
      redirect_to hr_employees_path, notice: "Employee record archived."
    end

    private

    def set_employee
      @employee = Hr::Employee.find(params[:id])
    end

    def load_form_collections
      @managers = policy_scope(Hr::Employee).where.not(id: @employee&.id).order(:staff_id)
      @departments = Hr::Employee.distinct.pluck(:department).compact.sort
    end

    def employee_params
      params.require(:hr_employee).permit(
        :department, :position_title, :hire_date, :status, :base_salary, :manager_id, :user_id,
        personal_detail_attributes: [
          :id, :first_name, :last_name, :dob, :gender, :bank_name,
          :account_number, :account_name, :means_of_identification,
          :id_number, :marital_status, :address, :phone_number
        ],
        next_of_kins_attributes: [:id, :name, :relationship, :phone_number, :address, :_destroy],
        # ADDED THIS FOR PRODUCTION
        recurring_adjustments_attributes: [:id, :label, :amount, :adjustment_type, :active, :_destroy]
      )
    end
  end
end
