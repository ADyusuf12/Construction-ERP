module Dashboard
  class HomeController < ApplicationController
    before_action :authenticate_user!

    def index
      @projects = policy_scope(Project).order(created_at: :desc).limit(5)

      @tasks = policy_scope(Task).order(created_at: :desc).limit(5)

      @reports = policy_scope(Report).order(created_at: :desc).limit(5)

      @transactions = policy_scope(Accounting::Transaction).order(created_at: :desc).limit(5)

      @employee = Hr::Employee.find_by(user_id: current_user.id)
      @leaves   = Hr::Leave.where(employee_id: @employee&.id)
                           .order(created_at: :desc)
                           .limit(5)
    end
  end
end
