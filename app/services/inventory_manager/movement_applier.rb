# app/services/inventory_manager/movement_applier.rb
module InventoryManager
  class MovementApplier
    def initialize(stock_movement, actor: nil)
      @movement = stock_movement
      @actor = actor # Useful to know who performed the movement
    end

    def call
      ActiveRecord::Base.transaction do
        case @movement.movement_type
        when "inbound"       then apply_inbound
        when "outbound"      then apply_outbound
        when "adjustment"    then apply_adjustment
        when "site_delivery" then apply_site_delivery
        else
          raise "unknown movement type: #{@movement.movement_type.inspect}"
        end

        # 1. Trigger oversight notification for financial/site events
        notify_of_significant_movement if significant_movement?

        # 2. Refresh status (this triggers threshold notifications if needed)
        @movement.inventory_item.refresh_status!

        @movement.update!(applied_at: Time.current)
      end
    end

    private

    def apply_inbound
      level = StockLevel.lock.find_or_create_by!(
        inventory_item: @movement.inventory_item,
        warehouse: @movement.destination_warehouse
      )
      level.increment!(:quantity, @movement.quantity)
    end

    def apply_outbound
      level = StockLevel.lock.find_or_create_by!(
        inventory_item: @movement.inventory_item,
        warehouse: @movement.source_warehouse
      )
      raise ActiveRecord::Rollback, "insufficient stock" if level.quantity < @movement.quantity
      level.decrement!(:quantity, @movement.quantity)
      update_project_inventory
      create_project_expense_if_needed
    end

    def apply_adjustment
      level = StockLevel.lock.find_or_create_by!(
        inventory_item: @movement.inventory_item,
        warehouse: @movement.destination_warehouse
      )
      level.update!(quantity: @movement.quantity)
    end

    def apply_site_delivery
      update_project_inventory
      create_project_expense_if_needed
    end

    def significant_movement?
      # Movements that affect project costs or indicate stock corrections
      %w[adjustment site_delivery].include?(@movement.movement_type)
    end

    def notify_of_significant_movement
      # Target financial/management roles
      recipients = User.where(role: [ :accountant, :ceo, :admin, :hr ])

      recipients.find_each do |user|
        user.notify(
          action: "movement_recorded",
          notifiable: @movement,
          actor: @actor,
          message: "Stock Alert: #{@movement.movement_type.humanize} processed for #{@movement.inventory_item.name} (#{@movement.quantity} units)."
        )
      end
    end

    def update_project_inventory
      return unless @movement.project.present?

      pi = ProjectInventory.lock.find_or_create_by!(
        project: @movement.project,
        inventory_item: @movement.inventory_item,
        task: @movement.task
      )

      if %w[outbound site_delivery].include?(@movement.movement_type)
        new_reserved = [ pi.quantity_reserved - @movement.quantity, 0 ].max
        pi.update!(quantity_reserved: new_reserved)
      end
    end

    def create_project_expense_if_needed
      return unless @movement.project.present?
      cost = @movement.unit_cost.presence || @movement.inventory_item.unit_cost

      ProjectExpense.create!(
        project: @movement.project,
        stock_movement: @movement,
        date: Time.current.to_date,
        description: "Stock movement (#{@movement.movement_type}) of #{@movement.quantity} #{@movement.inventory_item.name}",
        amount: @movement.quantity * cost
      )
    end
  end
end
