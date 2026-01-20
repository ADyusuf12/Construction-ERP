class CreateStockMovements < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_movements do |t|
      t.references :inventory_item, null: false, foreign_key: true
      t.references :warehouse, null: false, foreign_key: true
      t.integer :movement_type, null: false, default: 0  # enum: inbound, outbound, adjustment
      t.integer :quantity, null: false
      t.decimal :unit_cost, precision: 12, scale: 2
      t.references :user, foreign_key: { to_table: :users }, null: true
      t.string :reference
      t.text :notes
      t.timestamps
    end

    add_index :stock_movements, :movement_type
    add_index :stock_movements, :created_at
    add_index :stock_movements, [ :inventory_item_id, :created_at ], name: "index_stock_movements_on_item_and_created_at"
  end
end
