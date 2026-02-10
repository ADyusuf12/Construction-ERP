class AddCancelledToStockMovements < ActiveRecord::Migration[8.0]
  def change
    add_column :stock_movements, :cancelled_at, :datetime
    add_column :stock_movements, :cancellation_reason, :string
    add_column :stock_movements, :reversal_of_id, :integer
  end
end
