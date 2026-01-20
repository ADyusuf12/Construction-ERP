class CreateAccountingDeductions < ActiveRecord::Migration[8.0]
  def change
    create_table :accounting_deductions do |t|
      t.references :salary, null: false, foreign_key: { to_table: :accounting_salaries }
      t.integer :deduction_type, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.text :notes

      t.timestamps
    end
  end
end
