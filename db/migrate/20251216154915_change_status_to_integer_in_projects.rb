class ChangeStatusToIntegerInProjects < ActiveRecord::Migration[8.0]
  def change
    remove_column :projects, :status, :string
    add_column :projects, :status, :integer, default: 0, null: false
  end
end
