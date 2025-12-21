class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :project, null: false, foreign_key: true

      t.date    :date, null: false
      t.string  :description, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false

      t.integer :transaction_type, null: false, default: 0 # enum: invoice/receipt
      t.integer :status, null: false, default: 0           # enum: unpaid/paid

      t.string  :reference
      t.text    :notes

      t.timestamps
    end

    add_index :transactions, [:project_id, :date]
    add_index :transactions, :transaction_type
    add_index :transactions, :status
  end
end
