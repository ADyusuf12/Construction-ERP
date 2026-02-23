# app/models/inventory_item.rb
class InventoryItem < ApplicationRecord
  enum :status, { in_stock: 0, low_stock: 1, out_of_stock: 2 }

  validates :sku, presence: true, uniqueness: true, length: { in: 3..50 }
  validates :name, presence: true, length: { in: 3..150 }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :reorder_threshold, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :stock_movements, dependent: :restrict_with_error
  has_many :stock_levels, dependent: :delete_all
  has_many :project_inventories, dependent: :delete_all
  has_many :projects, through: :project_inventories
  has_many :warehouses, through: :stock_levels

  # Total quantity across all warehouses
  def total_quantity
    stock_levels.sum(:quantity)
  end

  # Total reserved quantity across all projects
  def reserved_quantity
    project_inventories.sum(:quantity_reserved)
  end

  # Available = warehouse stock minus reserved commitments
  def available_quantity
    total_quantity - reserved_quantity
  end

  # --- Status refresh & Notification Intelligence ---
  def refresh_status!
    qty = total_quantity
    new_status =
      if qty == 0
        :out_of_stock
      elsif qty <= reorder_threshold
        :low_stock
      else
        :in_stock
      end

    if status != new_status.to_s
      old_status = status
      # Use update_column to avoid triggering other callbacks recursively
      update_column(:status, InventoryItem.statuses[new_status])

      # Trigger alerts if dropping from 'in_stock' into a warning state
      if %w[low_stock out_of_stock].include?(new_status.to_s) && old_status == "in_stock"
        notify_inventory_stakeholders
      end
    end
  end

  private

  def notify_inventory_stakeholders
    # Target operational roles
    target_roles = [ :storekeeper, :site_manager, :ceo, :admin, :hr ]
    recipients = User.where(role: target_roles)

    recipients.find_each do |user|
      user.notify(
        action: "low_stock",
        notifiable: self,
        message: "Inventory Alert: #{name} is now #{status.humanize.downcase}. Current stock: #{total_quantity}."
      )
    end
  end
end
