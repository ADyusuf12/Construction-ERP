class CreateAccountingSalaries < ActiveRecord::Migration[8.0]
  def change
    create_table :accounting_salaries do |t|
      t.references :employee, null: false, foreign_key: { to_table: :hr_employees }
      t.references :batch, null: false, foreign_key: { to_table: :accounting_salary_batches }
      t.decimal :base_pay, precision: 12, scale: 2, null: false
      t.decimal :allowances, precision: 12, scale: 2, default: 0
      t.decimal :deductions_total, precision: 12, scale: 2, default: 0
      t.decimal :net_pay, precision: 12, scale: 2, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
