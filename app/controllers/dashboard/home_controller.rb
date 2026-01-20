module Dashboard
  class HomeController < ApplicationController
    before_action :authenticate_user!

    def index
      @projects = policy_scope(Project).order(created_at: :desc).limit(3)

      @tasks = policy_scope(Task).order(created_at: :desc).limit(3)

      @reports = policy_scope(Report).order(created_at: :desc).limit(3)

      @transactions = policy_scope(Accounting::Transaction).order(created_at: :desc).limit(3)
      @expenses = policy_scope(ProjectExpense).order(date: :desc).limit(3)

      @employee = Hr::Employee.find_by(user_id: current_user.id)
      @leaves   = Hr::Leave.where(employee_id: @employee&.id)
                           .order(created_at: :desc)
                           .limit(3)
    end
  end
end
