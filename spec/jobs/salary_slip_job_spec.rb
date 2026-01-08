require "rails_helper"

RSpec.describe SalarySlipJob, type: :job do
  let(:employee) { create(:hr_employee) }
  let(:batch)    { create(:accounting_salary_batch) }
  let!(:salary)  { create(:accounting_salary, employee: employee, batch: batch) }

  it "enqueues salary slip mailer for each salary in the batch" do
    # Stub the mailer to avoid actually sending emails
    mailer_double = double("SalarySlipMailer", deliver_later: true)
    allow(SalarySlipMailer).to receive(:with).and_return(mailer_double)
    allow(mailer_double).to receive(:deliver_slip).and_return(mailer_double)

    described_class.perform_now(batch.id)

    expect(SalarySlipMailer).to have_received(:with).with(
      hash_including(
        salary: salary,
        employee: salary.employee,
        personal_detail: salary.employee.personal_detail,
        user: salary.employee.user
      )
    )
    expect(mailer_double).to have_received(:deliver_slip)
    expect(mailer_double).to have_received(:deliver_later)
  end
end
