class ChangeProjectFiles < ActiveRecord::Migration[8.0]
  def change
    remove_column :project_files, :category, :integer, null: false, default: 4
    add_column :project_files, :title, :string
  end
end
