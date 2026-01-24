class AddUserIdToBusinessClients < ActiveRecord::Migration[8.0]
  def change
    add_reference :business_clients, :user, null: true, foreign_key: true
  end
end
