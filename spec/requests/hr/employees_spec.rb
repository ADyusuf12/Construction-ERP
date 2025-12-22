require 'rails_helper'

RSpec.describe "Hr::Employees", type: :request do
  let!(:employee) { create(:hr_employee) }

  describe "GET /index" do
    it "returns http success" do
      get hr_employees_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get hr_employee_path(employee)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_hr_employee_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get edit_hr_employee_path(employee)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a new employee" do
      expect {
        post hr_employees_path, params: {
          hr_employee: {
            department: "Finance",
            position_title: "Analyst",
            hire_date: Date.today,
            status: :active,
            leave_balance: 5,
            performance_score: 3.2
          }
        }
      }.to change(Hr::Employee, :count).by(1)
      expect(response).to redirect_to(hr_employees_path)
    end
  end

  describe "PATCH /update" do
    it "updates an employee" do
      patch hr_employee_path(employee), params: {
        hr_employee: { department: "Updated Dept" }
      }
      expect(response).to redirect_to(hr_employees_path)
      expect(employee.reload.department).to eq("Updated Dept")
    end
  end

  describe "DELETE /destroy" do
    it "deletes an employee" do
      expect {
        delete hr_employee_path(employee)
      }.to change(Hr::Employee, :count).by(-1)
      expect(response).to redirect_to(hr_employees_path)
    end
  end
end
