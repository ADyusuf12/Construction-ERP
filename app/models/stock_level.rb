class StockLevel < ApplicationRecord
  belongs_to :inventory_item
  belongs_to :warehouse

  validates :quantity, numericality: { only_integer: true }
end
