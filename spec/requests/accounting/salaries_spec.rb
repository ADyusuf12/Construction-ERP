require "rails_helper"

RSpec.describe "Accounting::Salaries", type: :request do
  let(:user)     { create(:user, :ceo) }
  let(:employee) { create(:hr_employee_with_detail) }
  let(:batch)    { create(:accounting_salary_batch) }
  # The salary is usually created by the batch callback, but we'll create one explicitly for testing show/update
  let(:salary)   { create(:accounting_salary, employee: employee, batch: batch, base_pay: 5000, allowances: 1000) }

  before { sign_in user, scope: :user }

  describe "GET /accounting/salaries" do
    it "returns success and lists all compensation records" do
      salary # trigger let
      get accounting_salaries_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /accounting/salaries/:id" do
    it "returns success and shows individual pay breakdown" do
      get accounting_salary_path(salary)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(employee.full_name)
    end
  end

  describe "PATCH /accounting/salaries/:id" do
    context "with valid params" do
      it "updates the pay record and redirects to the batch view" do
        patch accounting_salary_path(salary), params: {
          accounting_salary: { base_pay: 7000, allowances: 2000 }
        }

        # Verify redirection to the parent Batch
        expect(response).to redirect_to(accounting_salary_batch_path(batch))

        salary.reload
        expect(salary.base_pay).to eq(7000)
        # Verify that our model callback recalculated net_pay (7000 + 2000)
        expect(salary.net_pay).to eq(9000)

        follow_redirect!
        expect(response.body).to include("updated successfully")
      end
    end

    context "with invalid params" do
      it "returns unprocessable content and does not update" do
        patch accounting_salary_path(salary), params: {
          accounting_salary: { base_pay: -100 } # invalid numericality
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(salary.reload.base_pay).not_to eq(-100)
      end
    end
  end
end
