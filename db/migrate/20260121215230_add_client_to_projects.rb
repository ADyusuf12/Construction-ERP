class AddClientToProjects < ActiveRecord::Migration[8.0]
  def change
    add_reference :projects, :client, foreign_key: { to_table: :business_clients }
  end
end
