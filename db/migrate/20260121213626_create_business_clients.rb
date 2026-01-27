class CreateBusinessClients < ActiveRecord::Migration[8.0]
  def change
    create_table :business_clients do |t|
      t.string :name, null: false
      t.string :company
      t.string :email
      t.string :phone
      t.text   :address
      t.text   :notes

      t.timestamps
    end

    add_index :business_clients, :email, unique: true
    add_index :business_clients, :name
  end
end
