class CreateInventoryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :inventory_items do |t|
      t.string  :sku, null: false
      t.string  :name, null: false
      t.text    :description
      t.decimal :unit_cost, precision: 12, scale: 2, null: false, default: 0.0
      t.integer :status, null: false, default: 0
      t.integer :reorder_threshold, null: false, default: 5
      t.string  :default_location
      t.timestamps
    end

    add_index :inventory_items, :sku, unique: true
    add_index :inventory_items, :status
    add_index :inventory_items, :created_at
  end
end
