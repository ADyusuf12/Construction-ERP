class MigrateReportsToEmployees < ActiveRecord::Migration[8.0]
  def change
    add_reference :reports, :employee, foreign_key: { to_table: :hr_employees }, index: true

    # 2. Data Migration: Map existing reports to the correct employee
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE reports
          SET employee_id = hr_employees.id
          FROM hr_employees
          WHERE reports.user_id = hr_employees.user_id
        SQL
      end
    end

    remove_reference :reports, :user, foreign_key: true, index: true
  end
end
