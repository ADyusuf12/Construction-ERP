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

  # --- Inventory calculations ---
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

  # --- Status refresh ---
  def refresh_status!
    qty = total_quantity
    new_status =
      if qty <= 0
        :out_of_stock
      elsif qty <= reorder_threshold
        :low_stock
      else
        :in_stock
      end

    update_column(:status, InventoryItem.statuses[new_status]) unless status == new_status.to_s
  end
end
