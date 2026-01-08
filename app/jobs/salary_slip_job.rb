# app/jobs/salary_slip_job.rb
class SalarySlipJob < ApplicationJob
  queue_as :default

  def perform(batch_id)
    # Load the batch by ID
    batch = Accounting::SalaryBatch.find(batch_id)

    # Use the association to fetch salaries correctly
    batch.salaries.includes(:employee, :deductions).find_each do |salary|
      SalarySlipMailer.with(
        salary: salary,
        employee: salary.employee,
        personal_detail: salary.employee.personal_detail,
        user: salary.employee.user
      ).deliver_slip.deliver_later
    end
  end
end
