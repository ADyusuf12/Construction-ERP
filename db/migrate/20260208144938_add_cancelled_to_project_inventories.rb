class AddCancelledToProjectInventories < ActiveRecord::Migration[8.0]
  def change
    add_column :project_inventories, :cancelled_at, :datetime
    add_column :project_inventories, :cancellation_reason, :string
  end
end
