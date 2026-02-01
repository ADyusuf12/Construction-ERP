require "rails_helper"

RSpec.describe SalarySlipJob, type: :job do
  let(:batch) { create(:accounting_salary_batch) }
  let(:employee) { create(:hr_employee_with_detail) }
  let!(:salary) do
    create(:accounting_salary,
      batch: batch,
      employee: employee,
      base_pay: 1000.0,
      allowances: 200.0,
      status: :pending
    )
  end

  describe "#perform" do
    it "sends a salary slip email for each salary in the batch" do
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

      expect {
        described_class.perform_now(batch.id)
      }.to change { ActionMailer::Base.deliveries.count }.by(1)

      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to include("Salary Slip")
      expect(email.body.encoded).to include("₦1,200.00")
      expect(email.body.encoded).to include(employee.personal_detail.first_name)
    end

    it "marks slip_sent_at after sending" do
      expect(salary.slip_sent_at).to be_nil

      described_class.perform_now(batch.id)

      expect(salary.reload.slip_sent_at).to be_present
    end

    it "does not send duplicate slips if slip_sent_at is already set" do
      salary.update!(slip_sent_at: Time.current)

      expect {
        described_class.perform_now(batch.id)
      }.not_to change { ActionMailer::Base.deliveries.count }
    end

    it "processes multiple salaries in the batch" do
      other_employee = create(:hr_employee_with_detail)
      other_salary = create(:accounting_salary,
        batch: batch,
        employee: other_employee,
        base_pay: 1500.0,
        allowances: 300.0,
        status: :pending
      )

      expect {
        described_class.perform_now(batch.id)
      }.to change { ActionMailer::Base.deliveries.count }.by(2)

      expect(salary.reload.slip_sent_at).to be_present
      expect(other_salary.reload.slip_sent_at).to be_present
    end
  end

  describe "#perform_later" do
    before do
      ActiveJob::Base.queue_adapter = :test
    end

    it "enqueues the job with the batch id" do
      expect {
        described_class.perform_later(batch.id)
      }.to have_enqueued_job(described_class).with(batch.id)
    end

    it "uses the default queue" do
      expect {
        described_class.perform_later(batch.id)
      }.to have_enqueued_job.on_queue("default")
    end
  end
end
