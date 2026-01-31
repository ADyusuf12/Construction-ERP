class AddStockMovementIdToProjectExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :project_expenses, :stock_movement_id, :bigint
    add_index :project_expenses, :stock_movement_id
    add_foreign_key :project_expenses, :stock_movements
  end
end
