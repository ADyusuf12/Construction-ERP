require "rails_helper"

RSpec.describe "Accounting::SalaryBatches", type: :request do
  # We use the CEO trait to ensure Pundit authorization passes
  let(:user)  { create(:user, :ceo) }
  let(:batch) { create(:accounting_salary_batch) }

  # Explicitly naming the scope :user resolves the Devise mapping error
  before { sign_in user, scope: :user }

  describe "GET /accounting/salary_batches" do
    it "returns success and renders the index" do
      create_list(:accounting_salary_batch, 3)
      get accounting_salary_batches_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /accounting/salary_batches/:id" do
    it "returns success and shows generated salaries" do
      # Ensure there's a salary record to display
      create(:accounting_salary, batch: batch)
      get accounting_salary_batch_path(batch)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(batch.name)
    end
  end

  describe "POST /accounting/salary_batches" do
    context "with valid params and active staff" do
      before do
        # Create an active employee so the model callback has someone to process
        create(:hr_employee, status: :active, base_salary: 50000)
      end

      it "creates a batch, generates salaries, and redirects to the show page" do
        expect {
          post accounting_salary_batches_path, params: {
            accounting_salary_batch: {
              name: "March 2026 Payroll",
              period_start: Date.new(2026, 3, 1),
              period_end: Date.new(2026, 3, 31)
            }
          }
        }.to change(Accounting::SalaryBatch, :count).by(1)
         .and change(Accounting::Salary, :count).by_at_least(1)

        new_batch = Accounting::SalaryBatch.last
        expect(response).to redirect_to(accounting_salary_batch_path(new_batch))

        follow_redirect!
        expect(response.body).to include("Batch successfully initialized")
        expect(response.body).to include("salary records generated")
      end
    end

    context "with invalid params" do
      it "does not create a batch and returns unprocessable content" do
        expect {
          post accounting_salary_batches_path, params: {
            accounting_salary_batch: { name: "" }
          }
        }.not_to change(Accounting::SalaryBatch, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /accounting/salary_batches/:id/mark_paid" do
    it "marks all salaries as paid and redirects back to batch" do
      # Setup a batch with a salary record
      emp = create(:hr_employee, status: :active, base_salary: 50000)
      test_batch = create(:accounting_salary_batch)
      salary = test_batch.salaries.first # Created by callback

      patch mark_paid_accounting_salary_batch_path(test_batch)

      expect(test_batch.reload.status).to eq("paid")
      expect(test_batch.salaries.pluck(:status).uniq).to eq(["paid"])
      expect(response).to redirect_to(accounting_salary_batch_path(test_batch))

      follow_redirect!
      expect(response.body).to include("Disbursement complete")
    end
  end
end
