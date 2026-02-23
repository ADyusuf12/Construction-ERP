# app/services/hr/leave_manager/leave_requester.rb
module Hr
  module LeaveManager
    class LeaveRequester
      Result = Struct.new(:success?, :message, :leave)

      def initialize(employee, params)
        @employee = employee
        @params = params
      end

      def call
        leave = Hr::Leave.new(@params)
        leave.employee = @employee
        leave.manager = @employee.manager

        if leave.save
          notify_manager(leave)
          Result.new(true, "Leave request logged.", leave)
        else
          Result.new(false, leave.errors.full_messages.to_sentence, leave)
        end
      end

      private

      def notify_manager(leave)
        return unless @employee.manager&.user

        @employee.manager.user.notify(
          action: "leave_requested",
          notifiable: leave,
          actor: @employee.user,
          message: "New leave request: #{@employee.full_name} (#{leave.duration} days)"
        )
      end
    end
  end
end
