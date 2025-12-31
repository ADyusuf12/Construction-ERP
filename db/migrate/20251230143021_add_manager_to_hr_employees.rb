class AddManagerToHrEmployees < ActiveRecord::Migration[8.0]
  def change
    add_reference :hr_employees, :manager, foreign_key: { to_table: :hr_employees }
  end
end
