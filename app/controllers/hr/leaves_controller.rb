module Hr
  class LeavesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_leave, only: %i[ show approve reject cancel ]

    def index
      authorize Hr::Leave
      @leaves = policy_scope(Hr::Leave)
      if params[:status].present? && Hr::Leave.statuses.key?(params[:status])
        @leaves = @leaves.where(status: params[:status])
      end
    end

    def my_leaves
      @leaves = current_user.employee.leaves.order(start_date: :desc)
      authorize Hr::Leave, :my_leaves?
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
          format.html { redirect_to my_leaves_hr_leaves_path, notice: "Leave request submitted." }
          format.turbo_stream { redirect_to my_leaves_hr_leaves_path, notice: "Leave request submitted." }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def approve
      authorize @leave
      @leave.update!(status: :approved)
      @leave.apply_leave_balance!
      respond_to do |format|
        format.html { redirect_to hr_leaves_path, notice: "Leave approved." }
        format.turbo_stream
      end
    end

    def reject
      authorize @leave
      @leave.update!(status: :rejected)
      respond_to do |format|
        format.html { redirect_to hr_leaves_path, notice: "Leave rejected." }
        format.turbo_stream
      end
    end

    def cancel
      authorize @leave
      @leave.update!(status: :cancelled)
      respond_to do |format|
        format.html { redirect_to my_leaves_hr_leaves_path, notice: "Leave cancelled." }
        format.turbo_stream
      end
    end

    private

    def set_leave
      @leave = Hr::Leave.find(params[:id])
    end

    def leave_params
      params.require(:hr_leave).permit(:start_date, :end_date, :reason)
    end
  end
end
