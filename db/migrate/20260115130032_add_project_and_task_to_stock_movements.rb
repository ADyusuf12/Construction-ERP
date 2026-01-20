class AddProjectAndTaskToStockMovements < ActiveRecord::Migration[8.0]
  def change
    add_reference :stock_movements, :project, null: false, foreign_key: true
    add_reference :stock_movements, :task, null: false, foreign_key: true
  end
end
