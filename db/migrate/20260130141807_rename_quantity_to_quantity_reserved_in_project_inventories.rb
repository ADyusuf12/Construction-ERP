class RenameQuantityToQuantityReservedInProjectInventories < ActiveRecord::Migration[8.0]
  def change
    rename_column :project_inventories, :quantity, :quantity_reserved
  end
end
