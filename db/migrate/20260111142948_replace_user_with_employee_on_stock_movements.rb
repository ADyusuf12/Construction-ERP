class ReplaceUserWithEmployeeOnStockMovements < ActiveRecord::Migration[8.0]
  def change
    # Add employee reference first (nullable)
    add_reference :stock_movements, :employee, foreign_key: { to_table: :hr_employees }, null: true, index: true

    # If the user reference exists, remove it
    # Use remove_reference to drop the column and foreign key
    if column_exists?(:stock_movements, :user_id)
      remove_reference :stock_movements, :user, foreign_key: true
    end
  end
end
