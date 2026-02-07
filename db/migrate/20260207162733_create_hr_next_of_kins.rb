class CreateHrNextOfKins < ActiveRecord::Migration[8.0]
  def change
    create_table :hr_next_of_kins do |t|
      t.references :employee, null: false, foreign_key: { to_table: :hr_employees }

      t.string :name, null: false
      t.string :relationship, null: false
      t.string :phone_number, null: false
      t.string :address

      t.timestamps
    end
  end
end
