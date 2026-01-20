class RemoveProjectIdFromTransactions < ActiveRecord::Migration[8.0]
  def change
    # First drop foreign key if it exists
    remove_foreign_key :transactions, :projects rescue nil

    # Then drop indexes referencing project_id
    remove_index :transactions, name: "index_transactions_on_project_id_and_date" rescue nil
    remove_index :transactions, name: "index_transactions_on_project_id" rescue nil

    # Finally drop the column itself
    remove_column :transactions, :project_id, :bigint
  end
end
