class CreateHrPersonalDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :hr_personal_details do |t|
      t.references :employee, foreign_key: { to_table: :hr_employees, null: false, foreign_key: true }
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.integer :gender
      t.string :bank_name
      t.string :account_number
      t.string :account_name
      t.integer :means_of_identification
      t.string :id_number
      t.integer :marital_status
      t.text :address
      t.string :phone_number

      t.timestamps
    end
  end
end
