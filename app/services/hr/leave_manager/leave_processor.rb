# app/services/hr/leave_manager/leave_processor.rb
module Hr
  module LeaveManager
    class LeaveProcessor
      Result = Struct.new(:success?, :message)

      def initialize(leave, actor:) # Required actor
        @leave = leave
        @employee = leave.employee
        @actor = actor
      end

      def approve!
        return Result.new(false, "Only pending requests can be approved.") unless @leave.status_pending?

        Hr::Leave.transaction do
          if @employee.leave_balance >= @leave.duration
            @leave.update!(status: :approved)
            @employee.decrement!(:leave_balance, @leave.duration)

            send_notification("approved")
            Result.new(true, "Leave authorization granted. Balance updated.")
          else
            Result.new(false, "Insufficient balance.")
          end
        end
      end

      def reject!
        if @leave.update(status: :rejected)
          send_notification("rejected")
          Result.new(true, "Request declined.")
        else
          Result.new(false, "Failed to update status.")
        end
      end

      private

      def send_notification(status)
        return unless @employee.user

        @employee.user.notify(
          action: "leave_#{status}",
          notifiable: @leave,
          actor: @actor,
          message: "Your leave request for #{@leave.start_date.strftime('%b %d')} has been #{status}."
        )
      end
    end
  end
end
