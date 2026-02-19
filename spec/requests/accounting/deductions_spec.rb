require "rails_helper"

RSpec.describe "Accounting::Deductions", type: :request do
  let(:user)      { create(:user, :ceo) }
  # Ensure we have a clean hierarchy: Batch -> Salary -> Deduction
  let(:batch)     { create(:accounting_salary_batch) }
  let(:salary)    { create(:accounting_salary, batch: batch, base_pay: 10000, allowances: 2000) }
  let(:deduction) { create(:accounting_deduction, salary: salary, amount: 500) }

  before { sign_in user, scope: :user }

  describe "POST /accounting/deductions" do
    context "with valid params" do
      it "creates a deduction and updates the salary's net pay" do
        expect {
          post accounting_deductions_path, params: {
            accounting_deduction: {
              salary_id: salary.id,
              deduction_type: "tax",
              amount: 1000,
              notes: "Monthly Tax"
            }
          }
        }.to change(Accounting::Deduction, :count).by(1)

        # Verify redirection to the Salary Batch
        expect(response).to redirect_to(accounting_salary_batch_path(batch))

        # Verify the math: 10000 (base) + 2000 (allowance) - 1000 (deduction) = 11000
        salary.reload
        expect(salary.net_pay.to_f).to eq(11000.0)
        expect(salary.deductions_total.to_f).to eq(1000.0)

        follow_redirect!
        expect(response.body).to include("Net pay updated")
      end
    end
  end

  describe "PATCH /accounting/deductions/:id" do
    it "updates the deduction and recalculates salary net pay" do
      # Initial net pay with 500 deduction is 11500
      patch accounting_deduction_path(deduction), params: {
        accounting_deduction: { amount: 2000 }
      }

      expect(response).to redirect_to(accounting_salary_batch_path(batch))

      # New math: 12000 - 2000 = 10000
      salary.reload
      expect(salary.net_pay.to_f).to eq(10000.0)
      expect(deduction.reload.amount).to eq(2000)
    end
  end

  describe "DELETE /accounting/deductions/:id" do
    it "removes the deduction and restores the salary's net pay" do
      deduction # ensure the let variable is created

      expect {
        delete accounting_deduction_path(deduction)
      }.to change(Accounting::Deduction, :count).by(-1)

      expect(response).to redirect_to(accounting_salary_batch_path(batch))

      # Math: 10000 + 2000 - 0 = 12000
      salary.reload
      expect(salary.net_pay.to_f).to eq(12000.0)
      expect(salary.deductions_total.to_f).to eq(0.0)

      follow_redirect!
      expect(response.body).to include("Net pay restored")
    end
  end

  describe "GET /accounting/deductions" do
    it "returns success (Index)" do
      get accounting_deductions_path
      expect(response).to have_http_status(:ok)
    end
  end
end
