class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :details
      t.integer :status, default: 0, null: false
      t.datetime :due_date
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
