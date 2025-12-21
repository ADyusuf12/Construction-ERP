class AddWeightToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :weight, :integer, default: 1, null: false
  end
end
