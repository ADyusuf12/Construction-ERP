module Hr
  class LeavesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_leave, only: %i[ show approve reject destroy ]

    def index
      authorize Hr::Leave
      @leaves = policy_scope(Hr::Leave).order(created_at: :desc)

      if params[:status].present? && Hr::Leave.statuses.key?(params[:status])
        @leaves = @leaves.where(status: params[:status])
      end

      per_page = params.fetch(:per_page, 10).to_i
      @leaves = @leaves.page(params[:page]).per(per_page)
    end

    def my_leaves
      unless current_user&.employee
        redirect_to dashboard_home_path, alert: "Account error: No employee record linked."
        return
      end

      @leaves = policy_scope(Hr::Leave).where(employee: current_user.employee).order(created_at: :desc)

      if params[:status].present? && Hr::Leave.statuses.key?(params[:status])
        @leaves = @leaves.where(status: params[:status])
      end

      per_page = params.fetch(:per_page, 10).to_i
      @leaves = @leaves.page(params[:page]).per(per_page)
    end

    def show
      authorize @leave
    end

    def new
      @leave = Hr::Leave.new
      authorize @leave
    end

    def create
      @leave = Hr::Leave.new(leave_params)
      @leave.employee = current_user.employee
      @leave.manager  = current_user.employee.manager
      authorize @leave

      if @leave.save
        respond_to do |format|
          format.html { redirect_to my_leaves_hr_leaves_path, notice: "Leave request logged." }
          format.turbo_stream { redirect_to my_leaves_hr_leaves_path, notice: "Leave request logged." }
        end
      else
        render :new, status: :unprocessable_content
      end
    end

    def approve
      authorize @leave
      result = Hr::LeaveManager::LeaveProcessor.new(@leave).approve!

      # Use the message returned from the Service Result
      render_status_update(result.message)
    end

    def reject
      authorize @leave
      result = Hr::LeaveManager::LeaveProcessor.new(@leave).reject!

      render_status_update(result.message)
    end

    def destroy
      authorize @leave
      @leave.destroy

      respond_to do |format|
        format.html { redirect_to hr_leaves_path, notice: "Leave request removed from registry." }
        format.turbo_stream { flash.now[:notice] = "Leave request removed." } # Renders destroy.turbo_stream.erb
      end
    end

    private

    def set_leave
      @leave = Hr::Leave.find(params[:id])
    end

    def leave_params
      params.require(:hr_leave).permit(:start_date, :end_date, :reason)
    end

    def render_status_update(message)
      respond_to do |format|
        format.html { redirect_back fallback_location: hr_leaves_path, notice: message }
        format.turbo_stream do
          flash.now[:notice] = message
          render "hr/leaves/update"
        end
      end
    end
  end
end
