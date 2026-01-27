class AddClientToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :client, foreign_key: { to_table: :business_clients }
  end
end
