class CreateProjectFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :project_files do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :category, default: 4, null: false
      t.string :description
      t.timestamps
    end
  end
end
