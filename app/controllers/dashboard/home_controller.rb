# app/controllers/dashboard/home_controller.rb
module Dashboard
  class HomeController < ApplicationController
    before_action :authenticate_user!

    def index
      if current_user.role_admin? && current_user.employee.nil?
        redirect_to admin_users_path and return
      end
      # --- 1. Operations (The "Standard" Feed) ---
      @projects = policy_scope(Project).order(created_at: :desc).limit(3)
      @tasks = policy_scope(Task).where.not(status: :done).order(due_date: :asc).limit(3)
      @reports = policy_scope(Report).order(created_at: :desc).limit(3)

      # --- 2. Finance & Ledger Intelligence ---
      @transactions = policy_scope(Accounting::Transaction).order(date: :desc).limit(3)
      @expenses = policy_scope(ProjectExpense).order(date: :desc).limit(3)

      # CEO KPI: Cash flow visibility
      @pending_revenue = Accounting::Transaction.where(transaction_type: :invoice, status: :unpaid).sum(:amount)

      # --- 3. Logistics Intelligence (Inventory) ---
      @inventory_items = InventoryItem.all.includes(:stock_levels)
      @inventory_items = @inventory_items.sort_by { |item| item.total_quantity }

      @inventory_totals = @inventory_items.each_with_object({}) do |item, hash|
        hash[item.id] = item.total_quantity
      end

      @low_stock_items = @inventory_items.select do |item|
        threshold = item.reorder_threshold || 0
        (hash_total = @inventory_totals[item.id] || 0) <= threshold
      end

      # --- 4. HR Intelligence (Personnel) ---
      @employee = current_user.employee

      # Logic Refinement: Handle External Admins (who have no @employee record)
      if current_user.role_ceo? || current_user.role_admin? || current_user.role_hr?
        # High-level overview for Management
        @leaves = Hr::Leave.where(status: :pending).order(created_at: :desc).limit(5)
        @pending_leaves_count = Hr::Leave.where(status: :pending).count
      elsif @employee
        # Regular Staff: Show their personal records
        @leaves = @employee.leaves.order(created_at: :desc).limit(5)
        @pending_leaves_count = 0
      else
        # External Users/Clients with no HR records
        @leaves = []
        @pending_leaves_count = 0
      end
    end
  end
end
