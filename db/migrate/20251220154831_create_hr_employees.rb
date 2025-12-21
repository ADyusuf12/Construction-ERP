class CreateHrEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :hr_employees do |t|
      t.string :hamzis_id, null: false
      t.string :department
      t.string :position_title
      t.date :hire_date
      t.integer :status, default: 0 # enum: active, on_leave, terminated
      t.integer :leave_balance, default: 0
      t.decimal :performance_score, precision: 5, scale: 2
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end

    add_index :hr_employees, :hamzis_id, unique: true
  end
end
