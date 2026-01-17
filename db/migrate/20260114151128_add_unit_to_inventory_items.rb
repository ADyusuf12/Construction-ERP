class AddUnitToInventoryItems < ActiveRecord::Migration[8.0]
  def change
    add_column :inventory_items, :unit, :string, null: false, default: "pcs"
    add_index :inventory_items, :unit
  end
end
