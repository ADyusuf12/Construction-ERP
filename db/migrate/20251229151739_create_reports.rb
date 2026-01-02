class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.date :report_date, null: false
      t.integer :report_type, null: false, default: 0 # daily, weekly
      t.integer :status, null: false, default: 0      # draft, submitted, reviewed

      t.text :progress_summary
      t.text :issues
      t.text :next_steps

      t.timestamps
    end
  end
end
