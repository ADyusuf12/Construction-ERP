class MakeProjectAndTaskOptionalOnStockMovements < ActiveRecord::Migration[8.0]
  def change
    change_column_null :stock_movements, :project_id, true
    change_column_null :stock_movements, :task_id, true
  end
end
