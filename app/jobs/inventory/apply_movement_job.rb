module Inventory
  class ApplyMovementJob < ApplicationJob
    queue_as :default

    # Accepts a stock_movement id (matches how your model enqueues it)
    def perform(stock_movement_id)
      movement = StockMovement.find_by(id: stock_movement_id)
      return unless movement

      Inventory::MovementService.new(movement).perform!
    rescue StandardError => e
      Rails.logger.error("[Inventory::ApplyMovementJob] failed for id=#{stock_movement_id}: #{e.class} #{e.message}")
      raise
    end
  end
end
