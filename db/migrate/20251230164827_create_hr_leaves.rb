class CreateHrLeaves < ActiveRecord::Migration[8.0]
  def change
    create_table :hr_leaves do |t|
      t.references :employee, null: false, foreign_key: { to_table: :hr_employees }
      t.references :manager, foreign_key: { to_table: :hr_employees }
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :reason, null: false
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
