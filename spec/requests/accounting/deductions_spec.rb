require "rails_helper"

RSpec.describe "Accounting::Deductions", type: :request do
  let(:salary)    { create(:accounting_salary) }
  let(:deduction) { create(:accounting_deduction, salary: salary) }
  let(:user)      { create(:user, :ceo) } # CEO has full permissions

  before { sign_in user, scope: :user }

  describe "GET /accounting/deductions" do
    it "returns success" do
      get accounting_deductions_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /accounting/deductions/:id" do
    it "returns success" do
      get accounting_deduction_path(deduction)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /accounting/deductions" do
    context "with valid params" do
      it "creates a deduction" do
        expect {
          post accounting_deductions_path, params: {
            accounting_deduction: {
              salary_id: salary.id,
              deduction_type: "tax",
              amount: 250,
              notes: "Tax deduction"
            }
          }
        }.to change(Accounting::Deduction, :count).by(1)

        expect(response).to redirect_to(accounting_deductions_path)
        expect(Accounting::Deduction.last.amount).to eq(250)
      end
    end

    context "with invalid params" do
      it "does not create a deduction" do
        expect {
          post accounting_deductions_path, params: {
            accounting_deduction: {
              salary_id: salary.id,
              deduction_type: nil, # invalid
              amount: -50,
              notes: ""
            }
          }
        }.not_to change(Accounting::Deduction, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /accounting/deductions/:id" do
    it "updates a deduction" do
      patch accounting_deduction_path(deduction), params: {
        accounting_deduction: { amount: 400 }
      }
      expect(response).to redirect_to(accounting_deductions_path)
      expect(deduction.reload.amount).to eq(400)
    end
  end

  describe "DELETE /accounting/deductions/:id" do
    it "deletes a deduction" do
      deduction # ensure created
      expect {
        delete accounting_deduction_path(deduction)
      }.to change(Accounting::Deduction, :count).by(-1)
      expect(response).to redirect_to(accounting_deductions_path)
    end
  end
end
