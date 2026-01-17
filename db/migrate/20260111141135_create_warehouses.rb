class CreateWarehouses < ActiveRecord::Migration[8.0]
  def change
    create_table :warehouses do |t|
      t.string :name
      t.text :address
      t.string :code

      t.timestamps
    end
    add_index :warehouses, :code, unique: true
    add_index :warehouses, :name
  end
end
