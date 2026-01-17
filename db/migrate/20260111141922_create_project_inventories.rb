class CreateProjectInventories < ActiveRecord::Migration[8.0]
  def change
    create_table :project_inventories do |t|
      t.references :project, null: false, foreign_key: true
      t.references :inventory_item, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0
      t.string :purpose
      t.references :task, foreign_key: true, null: true
      t.timestamps
    end

    add_index :project_inventories, [ :project_id, :inventory_item_id ], unique: true, name: "index_project_inventories_on_project_and_item"
  end
end
