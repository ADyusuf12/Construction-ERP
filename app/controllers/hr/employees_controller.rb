module Hr
  class EmployeesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_employee, only: %i[ show edit update destroy ]
    before_action :load_form_collections, only: %i[new edit create update]

    # GET /hr/employees
    def index
      authorize Hr::Employee
      @employees = policy_scope(Hr::Employee)
      if params[:q].present?
        @employees = @employees.where("hamzis_id ILIKE ?", "%#{params[:q]}")
      end
    end

    # GET /hr/employees/:id
    def show
      authorize @employee
    end

    # GET /hr/employees/new
    def new
      @employee = Hr::Employee.new
      @employee.build_personal_detail
      authorize @employee
    end

    # GET /hr/employees/:id/edit
    def edit
      authorize @employee
      @employee.build_personal_detail if @employee.personal_detail.nil?
    end

    # POST /hr/employees
    def create
      @employee = Hr::Employee.new(employee_params)
      authorize @employee

      if @employee.save
        redirect_to hr_employees_path, notice: "Employee was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    # PATCH/PUT /hr/employees/:id
    def update
      authorize @employee
      if @employee.update(employee_params)
        redirect_to hr_employees_path, notice: "Employee was successfully updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    # DELETE /hr/employees/:id
    def destroy
      authorize @employee
      @employee.destroy
      redirect_to hr_employees_path, notice: "Employee was successfully deleted."
    end

    private

      def set_employee
        @employee = Hr::Employee.find(params[:id])
      end

      def load_form_collections
        @managers = policy_scope(Hr::Employee).order(:hamzis_id)
        @departments = Hr::Employee.distinct.pluck(:department).compact.sort
        @status_options = Hr::Employee.statuses.keys.map { |s| [ s.humanize, s ] }
        @gender_options = Hr::PersonalDetail.genders.keys.map { |g| [ g.humanize, g ] }
        @id_options = Hr::PersonalDetail.means_of_identifications.keys.map { |m| [ m.humanize, m ] }
        @marital_options = Hr::PersonalDetail.marital_statuses.keys.map { |m| [ m.humanize, m ] }
      end

      def employee_params
        params.require(:hr_employee).permit(
          :department, :position_title, :hire_date,
          :status, :leave_balance, :performance_score, :manager_id, :user_id,
          personal_detail_attributes: [
            :id, :first_name, :last_name, :dob, :gender,
            :bank_name, :account_number, :account_name,
            :means_of_identification, :id_number, :marital_status,
            :address, :phone_number
          ]
        )
      end
  end
end
