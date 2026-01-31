class RemoveWarehouseIdFromStockMovements < ActiveRecord::Migration[8.0]
  def change
    remove_column :stock_movements, :warehouse_id, :bigint
  end
end
