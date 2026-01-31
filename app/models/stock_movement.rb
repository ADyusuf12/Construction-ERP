class StockMovement < ApplicationRecord
  belongs_to :inventory_item
  belongs_to :source_warehouse, class_name: "Warehouse", optional: true
  belongs_to :destination_warehouse, class_name: "Warehouse", optional: true
  belongs_to :employee, class_name: "Hr::Employee", optional: true
  belongs_to :project, optional: true
  belongs_to :task, optional: true

  enum :movement_type, {
    inbound: 0,
    outbound: 1,
    adjustment: 2,
    site_delivery: 3
  }

  validates :movement_type, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :movement_logic

  def performed_by
    employee
  end

  def apply!
    ActiveRecord::Base.transaction do
      case movement_type
      when "inbound"
        level = StockLevel.lock.find_or_create_by!(inventory_item: inventory_item, warehouse: destination_warehouse)
        level.increment!(:quantity, quantity)

      when "outbound"
        level = StockLevel.lock.find_or_create_by!(inventory_item: inventory_item, warehouse: source_warehouse)
        raise ActiveRecord::Rollback, "insufficient stock" if level.quantity < quantity
        level.decrement!(:quantity, quantity)
        update_project_inventory
        create_project_expense_if_needed

      when "adjustment"
        level = StockLevel.lock.find_or_create_by!(inventory_item: inventory_item, warehouse: destination_warehouse)
        level.update!(quantity: quantity)

      when "site_delivery"
        update_project_inventory
        create_project_expense_if_needed

      else
        raise "unknown movement type: #{movement_type.inspect}"
      end

      inventory_item.refresh_status!
      update!(applied_at: Time.current)
    end
  end

  private

  def movement_logic
    case movement_type
    when "inbound"
      errors.add(:destination_warehouse, "must be set") if destination_warehouse.blank?
    when "outbound"
      errors.add(:source_warehouse, "must be set") if source_warehouse.blank?
      errors.add(:project, "must be set") if project.blank?

      if project.present?
        pi = ProjectInventory.find_by(project: project, inventory_item: inventory_item, task: task)
        if pi && quantity > pi.quantity_reserved
          errors.add(:quantity, "exceeds reserved amount (#{pi.quantity_reserved}) for this project")
        end
      end
    when "adjustment"
      errors.add(:destination_warehouse, "must be set") if destination_warehouse.blank?
    when "site_delivery"
      errors.add(:project, "must be set") if project.blank?
    end
  end

  def update_project_inventory
    return unless project.present?

    pi = ProjectInventory.lock.find_or_create_by!(
      project: project,
      inventory_item: inventory_item,
      task: task
    )

    # Business decision: issuing stock reduces reservation
    if movement_type == "outbound"
      # reduce reservation if any exists
      new_reserved = [ pi.quantity_reserved - quantity, 0 ].max
      pi.update!(quantity_reserved: new_reserved)
    end

    # site_delivery and outbound both increase what’s physically at site
    # (issued_quantity is calculated from StockMovement records, so no direct column update needed here)
  end

  def create_project_expense_if_needed
    return unless project.present? && unit_cost.present?

    ProjectExpense.create!(
      project: project,
      stock_movement: self,
      date: Time.current.to_date,
      description: "Stock movement (#{movement_type}) of #{quantity} #{inventory_item.name}",
      amount: quantity * unit_cost
    )
  end
end
