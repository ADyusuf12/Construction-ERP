class RemoveProgressFromProjects < ActiveRecord::Migration[8.0]
  def change
    remove_column :projects, :progress, :integer
  end
end
