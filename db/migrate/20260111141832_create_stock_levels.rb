class CreateStockLevels < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_levels do |t|
      t.references :inventory_item, null: false, foreign_key: true
      t.references :warehouse, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0
      t.integer :lock_version, null: false, default: 0  # optional optimistic locking
      t.timestamps
    end

    add_index :stock_levels, [ :inventory_item_id, :warehouse_id ], unique: true, name: "index_stock_levels_on_item_and_warehouse"
  end
end
