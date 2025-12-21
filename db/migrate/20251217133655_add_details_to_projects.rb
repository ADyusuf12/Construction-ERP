class AddDetailsToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :deadline, :datetime
    add_column :projects, :budget, :decimal, precision: 12, scale: 2
    add_column :projects, :progress, :integer, default: 0, null: false
  end
end
