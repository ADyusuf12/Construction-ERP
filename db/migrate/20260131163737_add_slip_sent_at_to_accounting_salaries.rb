class AddSlipSentAtToAccountingSalaries < ActiveRecord::Migration[8.0]
  def change
    add_column :accounting_salaries, :slip_sent_at, :datetime
  end
end
