class AddDefaultStatusToTasks < ActiveRecord::Migration[8.0]
  def change
    change_column_default :tasks, :status, 0
  end
end
