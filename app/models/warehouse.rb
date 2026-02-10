class Warehouse < ApplicationRecord
  has_many :source_stock_movements,
           class_name: "StockMovement",
           foreign_key: "source_warehouse_id",
           dependent: :restrict_with_error

  has_many :destination_stock_movements,
           class_name: "StockMovement",
           foreign_key: "destination_warehouse_id",
           dependent: :restrict_with_error

  has_many :stock_levels, dependent: :delete_all
  has_many :inventory_items, through: :stock_levels
  has_many :project_inventories, dependent: :restrict_with_error

  validates :name, presence: true, length: { in: 2..100 }
  validates :code, uniqueness: true, allow_blank: true

  # --- Business Logic ---

  def total_stock_value
    stock_levels.joins(:inventory_item).sum("stock_levels.quantity * inventory_items.unit_cost")
  end

  def recent_movements(limit = 10)
    StockMovement.where("source_warehouse_id = :id OR destination_warehouse_id = :id", id: id)
                 .includes(:inventory_item, :project, :employee)
                 .order(created_at: :desc)
                 .limit(limit)
  end
end
