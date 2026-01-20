# app/services/inventory/movement_service.rb
module Inventory
  class MovementService
    def initialize(stock_movement)
      @movement = stock_movement
      @item = @movement.inventory_item
      @warehouse = @movement.warehouse
    end

    def perform!
      ActiveRecord::Base.transaction do
        @movement.reload
        return if @movement.applied_at.present?

        level = StockLevel.lock.find_or_create_by!(inventory_item: @item, warehouse: @warehouse)

        case @movement.movement_type.to_s
        when "inbound"
          level.update!(quantity: level.quantity + @movement.quantity)
        when "outbound"
          # business decision: rollback when insufficient stock
          raise ActiveRecord::Rollback, "insufficient stock" if level.quantity < @movement.quantity
          level.update!(quantity: level.quantity - @movement.quantity)
        when "adjustment"
          level.update!(quantity: level.quantity + @movement.quantity)
        else
          raise "unknown movement type: #{@movement.movement_type.inspect}"
        end

        @item.refresh_status!

        # mark movement applied atomically with stock update
        @movement.update!(applied_at: Time.current)
      end
    end
  end
end
