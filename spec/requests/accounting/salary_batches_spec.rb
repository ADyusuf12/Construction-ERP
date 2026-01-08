require "rails_helper"

RSpec.describe "Accounting::SalaryBatches", type: :request do
  let(:batch) { create(:accounting_salary_batch) }
  let(:user)  { create(:user, :ceo) } # CEO has full permissions

  before { sign_in user, scope: :user }

  describe "GET /accounting/salary_batches" do
    it "returns success" do
      get accounting_salary_batches_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /accounting/salary_batches/:id" do
    it "returns success" do
      get accounting_salary_batch_path(batch)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /accounting/salary_batches" do
    context "with valid params" do
      it "creates a batch" do
        expect {
          post accounting_salary_batches_path, params: {
            accounting_salary_batch: {
              name: "February Payroll",
              period_start: Date.today.beginning_of_month,
              period_end: Date.today.end_of_month,
              status: "pending"
            }
          }
        }.to change(Accounting::SalaryBatch, :count).by(1)

        expect(response).to redirect_to(accounting_salary_batches_path)
        expect(Accounting::SalaryBatch.last.name).to eq("February Payroll")
      end
    end

    context "with invalid params" do
      it "does not create a batch" do
        expect {
          post accounting_salary_batches_path, params: {
            accounting_salary_batch: {
              name: "",
              period_start: nil,
              period_end: nil,
              status: "pending"
            }
          }
        }.not_to change(Accounting::SalaryBatch, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /accounting/salary_batches/:id" do
    it "updates a batch" do
      patch accounting_salary_batch_path(batch), params: {
        accounting_salary_batch: { name: "Updated Payroll" }
      }
      expect(response).to redirect_to(accounting_salary_batches_path)
      expect(batch.reload.name).to eq("Updated Payroll")
    end
  end

  describe "PATCH /accounting/salary_batches/:id/mark_paid" do
    it "marks batch as paid" do
      patch mark_paid_accounting_salary_batch_path(batch)
      expect(response).to redirect_to(accounting_salary_batches_path)
      expect(batch.reload.status).to eq("paid")
    end
  end

  describe "DELETE /accounting/salary_batches/:id" do
    it "deletes a batch" do
      batch # ensure created
      expect {
        delete accounting_salary_batch_path(batch)
      }.to change(Accounting::SalaryBatch, :count).by(-1)
      expect(response).to redirect_to(accounting_salary_batches_path)
    end
  end
end
