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
      authorize Hr::Leave

      # Use the Requester service to handle creation and manager notification
      result = Hr::LeaveManager::LeaveRequester.new(current_user.employee, leave_params).call
      @leave = result.leave

      if result.success?
        respond_to do |format|
          format.html { redirect_to my_leaves_hr_leaves_path, notice: result.message }
          format.turbo_stream { redirect_to my_leaves_hr_leaves_path, notice: result.message }
        end
      else
        render :new, status: :unprocessable_content
      end
    end

    def approve
      authorize @leave
      # Use the Processor service with current_user as the 'actor'
      result = Hr::LeaveManager::LeaveProcessor.new(@leave, actor: current_user).approve!

      render_status_update(result.message)
    end

    def reject
      authorize @leave
      # Use the Processor service with current_user as the 'actor'
      result = Hr::LeaveManager::LeaveProcessor.new(@leave, actor: current_user).reject!

      render_status_update(result.message)
    end

    def destroy
      authorize @leave
      @leave.destroy

      respond_to do |format|
        format.html { redirect_to hr_leaves_path, notice: "Leave request removed from registry." }
        format.turbo_stream { flash.now[:notice] = "Leave request removed." }
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
          # This renders update.turbo_stream.erb to refresh the row in the UI
          render "hr/leaves/update"
        end
      end
    end
  end
end
