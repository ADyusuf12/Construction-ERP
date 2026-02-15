class MigrateAssignmentsToEmployees < ActiveRecord::Migration[8.0]
  def change
    add_reference :assignments, :employee, foreign_key: { to_table: :hr_employees }, index: true

    # 2. Data Migration: Link current assignments to the user's employee record
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE assignments
          SET employee_id = hr_employees.id
          FROM hr_employees
          WHERE assignments.user_id = hr_employees.user_id
        SQL
      end
    end

    remove_reference :assignments, :user, foreign_key: true, index: true
  end
end
