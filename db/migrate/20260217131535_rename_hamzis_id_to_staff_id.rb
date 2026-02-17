class RenameHamzisIdToStaffId < ActiveRecord::Migration[8.0]
  def change
    rename_column :hr_employees, :staff_id, :staff_id
  end
end
