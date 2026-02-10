class ProjectInventory < ApplicationRecord
  belongs_to :project
  belongs_to :inventory_item
  belongs_to :task, optional: true
  belongs_to :warehouse, optional: true

  validates :quantity_reserved, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :warehouse_has_item_stock, if: -> { warehouse_id.present? && inventory_item_id.present? }

  after_commit :touch_inventory_item

  def issued_quantity
    StockMovement.active.where(
      project: project,
      inventory_item: inventory_item,
      movement_type: [ :outbound, :site_delivery ]
    ).sum(:quantity)
  end

  def outstanding_reservation
    [ quantity_reserved - issued_quantity, 0 ].max
  end

  def site_quantity
    issued_quantity
  end

  # --- cancellation API ---
  def cancelled?
    cancelled_at.present? || quantity_reserved.zero?
  end

  # Idempotent cancel: set reserved qty to 0, record reason and timestamp, touch item
  def cancel!(reason: nil)
    return if cancelled?

    transaction do
      update!(
        quantity_reserved: 0,
        cancelled_at: Time.current,
        cancellation_reason: reason
      )
      touch_inventory_item
    end
  end

  private

  def touch_inventory_item
    inventory_item.touch(:updated_at)
  end

  def warehouse_has_item_stock
    stock_level = StockLevel.find_by(inventory_item_id: inventory_item_id, warehouse_id: warehouse_id)
    if stock_level.nil? || stock_level.quantity <= 0
      errors.add(:warehouse_id, "does not have this item in stock")
    elsif quantity_reserved > stock_level.quantity
      errors.add(:quantity_reserved, "exceeds available stock in warehouse (#{stock_level.quantity})")
    end
  end
end
