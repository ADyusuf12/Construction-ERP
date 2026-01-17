class Warehouse < ApplicationRecord
  has_many :stock_movements, dependent: :restrict_with_error
  has_many :stock_levels, dependent: :delete_all
  has_many :inventory_items, through: :stock_levels

  validates :name, presence: true, length: { in: 2..100 }
  validates :code, uniqueness: true, allow_blank: true

  def total_stock_value
    stock_levels.joins(:inventory_item).sum("stock_levels.quantity * inventory_items.unit_cost")
  end

  def recent_movements(limit = 10)
    stock_movements.includes(:inventory_item, :project, :employee)
                    .order(created_at: :desc)
                    .limit(limit)
  end
end
