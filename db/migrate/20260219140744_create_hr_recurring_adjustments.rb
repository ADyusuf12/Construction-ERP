class CreateHrRecurringAdjustments < ActiveRecord::Migration[8.0]
  def change
    create_table :hr_recurring_adjustments do |t|
      t.references :employee, null: false, foreign_key: { to_table: :hr_employees }
      t.string :label, null: false # e.g., "Monthly Pension"
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.integer :adjustment_type, null: false, default: 0 # enum: { deduction: 0, allowance: 1 }
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
