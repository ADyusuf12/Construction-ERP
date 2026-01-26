class AddLocationToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :location, :string
    add_column :projects, :address, :string
  end
end
