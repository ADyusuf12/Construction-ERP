class CreateProjectExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :project_expenses do |t|
      t.references :project, null: false, foreign_key: true
      t.date :date, null: false
      t.string :description, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string :reference
      t.text :notes

      t.timestamps
    end
  end
end
