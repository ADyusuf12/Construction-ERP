module InventoryManager
  class MovementCanceller
    def initialize(stock_movement)
      @movement = stock_movement
    end

    def call
      case @movement.movement_type
      when "inbound"
        cancel_inbound
      when "outbound"
        cancel_outbound
      when "site_delivery"
        cancel_site_delivery
      when "adjustment"
        cancel_adjustment
      end

      # Delete linked expense if present
      @movement.project_expense&.destroy
    end

    private

    def cancel_inbound
      level = StockLevel.lock.find_by!(
        inventory_item: @movement.inventory_item,
        warehouse: @movement.destination_warehouse
      )
      level.decrement!(:quantity, @movement.quantity)
    end

    def cancel_outbound
      level = StockLevel.lock.find_by!(
        inventory_item: @movement.inventory_item,
        warehouse: @movement.source_warehouse
      )
      level.increment!(:quantity, @movement.quantity)

      if @movement.project.present?
        pi = ProjectInventory.lock.find_by!(
          project: @movement.project,
          inventory_item: @movement.inventory_item,
          task: @movement.task
        )
        # Restore reservation balance
        pi.update!(quantity_reserved: pi.quantity_reserved + @movement.quantity)
      end
    end

    def cancel_site_delivery
      if @movement.project.present?
        pi = ProjectInventory.lock.find_by!(
          project: @movement.project,
          inventory_item: @movement.inventory_item,
          task: @movement.task
        )
        # Restore reservation balance
        pi.update!(quantity_reserved: pi.quantity_reserved + @movement.quantity)
      end
    end

    def cancel_adjustment
      level = StockLevel.lock.find_by!(
        inventory_item: @movement.inventory_item,
        warehouse: @movement.destination_warehouse
      )
      level.update!(quantity: 0)
    end
  end
end
