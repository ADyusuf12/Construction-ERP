class AddReversalOfToProjectExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :project_expenses, :reversal_of_id, :integer
  end
end
