module Hr
  class AttendanceRecordsController < ApplicationController
    include Pundit::Authorization

    before_action :authenticate_user!
    before_action :set_attendance_record, only: [ :show, :edit, :update, :destroy ]

    def index
      authorize Hr::AttendanceRecord
      @attendance_records = policy_scope(Hr::AttendanceRecord).includes(:employee, :project)

      if params[:employee_id].present?
        @employee = Hr::Employee.find(params[:employee_id])
        @attendance_records = @attendance_records.where(employee: @employee)
      end

      if params[:status].present?
        @attendance_records = @attendance_records.where(status: params[:status])
      end

      if params[:date].present?
        begin
          date = Date.parse(params[:date])
          @attendance_records = @attendance_records.where(date: date)
        rescue ArgumentError
          flash.now[:alert] = "Invalid date format for filter"
        end
      end

      @attendance_records = @attendance_records.order(date: :desc)

      per_page = params.fetch(:per_page, 10).to_i
      @attendance_records = @attendance_records.page(params[:page]).per(per_page)
    end

    def my_attendance
      unless current_user&.employee
        @attendance_records = Hr::AttendanceRecord.none.page(params[:page]).per(25)
        flash[:alert] = "You are not linked to an employee record."
        return
      end

      @attendance_records = policy_scope(Hr::AttendanceRecord)
                            .where(employee: current_user.employee)
                            .includes(:project)
                            .order(date: :desc)

      # Filters
      if params[:status].present?
        @attendance_records = @attendance_records.where(status: params[:status])
      end

      if params[:date].present?
        begin
          date = Date.parse(params[:date])
          @attendance_records = @attendance_records.where(date: date)
        rescue ArgumentError
          flash.now[:alert] = "Invalid date format for filter"
        end
      end

      # Kaminari pagination
      per_page = params.fetch(:per_page, 25).to_i
      @attendance_records = @attendance_records.page(params[:page]).per(per_page)
    end

    def show
      # @attendance_record is authorized in set_attendance_record
    end

    def new
      @attendance_record = Hr::AttendanceRecord.new
      authorize @attendance_record
    end

    def create
      @attendance_record = Hr::AttendanceRecord.new(attendance_record_params)

      if current_user.employee && !policy(Hr::AttendanceRecord).index?
        @attendance_record.employee = current_user.employee
      end

      authorize @attendance_record

      if @attendance_record.save
        redirect_to hr_attendance_record_path(@attendance_record), notice: "Attendance record created."
      else
        render :new
      end
    end

    def edit
      # @attendance_record is authorized in set_attendance_record
    end

    def update
      if @attendance_record.update(attendance_record_params)
        redirect_to hr_attendance_record_path(@attendance_record), notice: "Attendance record updated."
      else
        render :edit
      end
    end

    def destroy
      @attendance_record.destroy
      redirect_to hr_attendance_records_path, notice: "Attendance record deleted."
    end

    private

    def set_attendance_record
      @attendance_record = Hr::AttendanceRecord.find(params[:id])
      authorize @attendance_record
    end

    def attendance_record_params
      params.require(:attendance_record).permit(:employee_id, :project_id, :date, :status, :check_in_time, :check_out_time)
    end
  end
end
