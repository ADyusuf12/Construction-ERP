require "rails_helper"

RSpec.describe SalarySlipMailer, type: :mailer do
  let(:employee)        { create(:hr_employee) }
  let(:batch)           { create(:accounting_salary_batch, name: "January Payroll") }
  let(:salary)          { create(:accounting_salary, employee: employee, batch: batch) }
  let(:personal_detail) { employee.personal_detail }
  let(:user)            { employee.user }

  describe "#deliver_slip" do
    subject(:mail) do
      described_class.with(
        salary: salary,
        employee: employee,
        personal_detail: personal_detail,
        user: user
      ).deliver_slip
    end

    it "renders the headers" do
      expect(mail.to).to eq([ user.email ])
      expect(mail.subject).to eq("Your Salary Slip for #{salary.batch.period_label}")
    end

    it "assigns instance variables" do
      expect(mail.body.encoded).to include(employee.full_name) if employee.respond_to?(:full_name)
      expect(mail.body.encoded).to include(ActionController::Base.helpers.number_to_currency(salary.base_pay, unit: "₦"))
    end
  end
end
