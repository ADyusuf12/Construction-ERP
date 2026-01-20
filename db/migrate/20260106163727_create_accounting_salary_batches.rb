class CreateAccountingSalaryBatches < ActiveRecord::Migration[8.0]
  def change
    create_table :accounting_salary_batches do |t|
      t.string :name
      t.date :period_start
      t.date :period_end
      t.integer :status

      t.timestamps
    end
  end
end
