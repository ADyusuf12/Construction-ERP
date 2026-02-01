class SalarySlipJob < ApplicationJob
  queue_as :default

  def perform(batch_id)
    batch = Accounting::SalaryBatch.find(batch_id)

    batch.salaries.includes(:employee).find_each do |salary|
      next if salary.slip_sent_at.present? # idempotency check

      SalarySlipMailer.with(
        salary: salary,
        employee: salary.employee,
        personal_detail: salary.employee.personal_detail,
        user: salary.employee.user
      ).deliver_slip.deliver_now

      salary.update!(slip_sent_at: Time.current)
    end
  end
end
