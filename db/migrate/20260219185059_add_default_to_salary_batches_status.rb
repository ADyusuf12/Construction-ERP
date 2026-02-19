class AddDefaultToSalaryBatchesStatus < ActiveRecord::Migration[8.0]
  def change
    Accounting::SalaryBatch.where(status: nil).update_all(status: 0)

    change_column_default :accounting_salary_batches, :status, from: nil, to: 0
    change_column_null :accounting_salary_batches, :status, false
  end
end
