class CreateHrAttendanceRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :hr_attendance_records do |t|
      t.references :employee, null: false, foreign_key: { to_table: :hr_employees }
      t.references :project, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :status, null: false
      t.datetime :check_in_time
      t.datetime :check_out_time

      t.timestamps
    end

    add_index :hr_attendance_records, [ :employee_id, :date ], unique: true
  end
end
