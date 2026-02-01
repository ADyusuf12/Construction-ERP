require "rails_helper"

RSpec.describe "Accounting::Salaries", type: :request do
  let(:employee) { create(:hr_employee) }
  let(:batch)    { create(:accounting_salary_batch) }
  let(:salary)   { create(:accounting_salary, employee: employee, batch: batch) }
  let(:user)     { create(:user, :ceo) } # CEO has full permissions

  before { sign_in user, scope: :user }

  describe "GET /accounting/salaries" do
    it "returns success" do
      get accounting_salaries_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /accounting/salaries/:id" do
    it "returns success" do
      get accounting_salary_path(salary)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /accounting/salaries" do
    context "with valid params" do
      it "creates a salary" do
        expect {
          post accounting_salaries_path, params: {
            accounting_salary: {
              employee_id: employee.id,
              batch_id: batch.id,
              base_pay: 1200,
              allowances: 300,
              status: "pending"
            }
          }
        }.to change(Accounting::Salary, :count).by(1)

        expect(response).to redirect_to(accounting_salaries_path)
        expect(Accounting::Salary.last.base_pay).to eq(1200)
      end
    end

    context "with invalid params" do
      it "does not create a salary" do
        expect {
          post accounting_salaries_path, params: {
            accounting_salary: {
              employee_id: employee.id,
              batch_id: batch.id,
              base_pay: nil, # invalid
              allowances: 300,
              status: "pending"
            }
          }
        }.not_to change(Accounting::Salary, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /accounting/salaries/:id" do
    it "updates a salary" do
      patch accounting_salary_path(salary), params: {
        accounting_salary: { base_pay: 1500 }
      }
      expect(response).to redirect_to(accounting_salaries_path)
      expect(salary.reload.base_pay).to eq(1500)
    end
  end

  describe "DELETE /accounting/salaries/:id" do
    it "deletes a salary" do
      salary # ensure created
      expect {
        delete accounting_salary_path(salary)
      }.to change(Accounting::Salary, :count).by(-1)
      expect(response).to redirect_to(accounting_salaries_path)
    end
  end
end
