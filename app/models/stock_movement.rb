class StockMovement < ApplicationRecord
  belongs_to :inventory_item
  belongs_to :source_warehouse, class_name: "Warehouse", optional: true
  belongs_to :destination_warehouse, class_name: "Warehouse", optional: true
  belongs_to :employee, class_name: "Hr::Employee", optional: true
  belongs_to :project, optional: true
  belongs_to :task, optional: true

  has_one :project_expense, dependent: :nullify

  enum :movement_type, { inbound: 0, outbound: 1, adjustment: 2, site_delivery: 3 }

  validates :movement_type, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :active, -> { where(cancelled_at: nil) }

  def cancelled?
    cancelled_at.present?
  end

  def apply!
    InventoryManager::MovementApplier.new(self).call
  end

  def cancel!(reason: nil)
    ActiveRecord::Base.transaction do
      InventoryManager::MovementCanceller.new(self).call
      update!(cancelled_at: Time.current, cancellation_reason: reason)
    end
  end

  def performed_by
    employee
  end

  private

  def movement_logic
    return if cancelled?

    case movement_type
    when "inbound"
      errors.add(:destination_warehouse, "must be set") if destination_warehouse.blank?
    when "outbound"
      errors.add(:source_warehouse, "must be set") if source_warehouse.blank?
      errors.add(:project, "must be set") if project.blank?
    when "adjustment"
      errors.add(:destination_warehouse, "must be set") if destination_warehouse.blank?
    when "site_delivery"
      errors.add(:project, "must be set") if project.blank?
    end
  end
end
