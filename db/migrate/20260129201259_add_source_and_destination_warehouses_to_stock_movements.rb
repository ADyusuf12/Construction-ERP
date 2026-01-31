class AddSourceAndDestinationWarehousesToStockMovements < ActiveRecord::Migration[8.0]
  def change
    add_column :stock_movements, :source_warehouse_id, :bigint
    add_column :stock_movements, :destination_warehouse_id, :bigint

    add_index :stock_movements, :source_warehouse_id
    add_index :stock_movements, :destination_warehouse_id
  end
end
