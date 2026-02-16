module Hr
  module LeaveManager
    class LeaveProcessor
      # Define a simple result object for the controller to read
      Result = Struct.new(:success?, :message)

      def initialize(leave)
        @leave = leave
        @employee = leave.employee
      end

      def approve!
        return Result.new(false, "Only pending requests can be approved.") unless @leave.status_pending?

        # Wrap in a transaction so we don't approve the leave but fail the balance update
        Hr::Leave.transaction do
          if @employee.leave_balance >= @leave.duration
            @leave.update!(status: :approved)
            @employee.decrement!(:leave_balance, @leave.duration)

            Result.new(true, "Leave authorization granted. Balance updated.")
          else
            Result.new(false, "Insufficient balance. Available: #{@employee.leave_balance} days.")
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        Result.new(false, "System Error: #{e.record.errors.full_messages.to_sentence}")
      rescue StandardError => e
        Result.new(false, "An unexpected error occurred: #{e.message}")
      end

      def reject!
        if @leave.update(status: :rejected)
          Result.new(true, "Request declined.")
        else
          Result.new(false, "Failed to update request status.")
        end
      end
    end
  end
end
