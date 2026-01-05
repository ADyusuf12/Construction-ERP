# spec/requests/hr/employees_spec.rb
require "rails_helper"

RSpec.describe "Hr::Employees", type: :request do
  let(:ceo)        { create(:user, :ceo) }
  let(:admin)      { create(:user, :admin) }
  let(:hr_user)    { create(:user, :hr) }
  let(:cto)        { create(:user, :cto) }
  let(:site_manager) { create(:user, :site_manager) }
  let(:qs)         { create(:user, :qs) }
  let(:engineer)   { create(:user, :engineer) }
  let(:storekeeper) { create(:user, :storekeeper) }
  let(:accountant) { create(:user, :accountant) }

  let!(:employee) { create(:hr_employee, user: hr_user) }

  describe "GET /hr/employees" do
    it "requires login" do
      get hr_employees_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows logged in CEO" do
      sign_in ceo
      get hr_employees_path
      expect(response).to have_http_status(:ok)
    end

    it "allows logged in Admin" do
      sign_in admin
      get hr_employees_path
      expect(response).to have_http_status(:ok)
    end

    it "allows logged in HR" do
      sign_in hr_user
      get hr_employees_path
      expect(response).to have_http_status(:ok)
    end

    it "allows logged in CTO" do
      sign_in cto
      get hr_employees_path
      expect(response).to have_http_status(:ok)
    end

    it "allows logged in Site Manager" do
      sign_in site_manager
      get hr_employees_path
      expect(response).to have_http_status(:ok)
    end

    it "denies QS" do
      sign_in qs
      get hr_employees_path
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
    end

    it "denies Engineer" do
      sign_in engineer
      get hr_employees_path
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
    end

    it "denies Storekeeper" do
      sign_in storekeeper
      get hr_employees_path
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
    end

    it "denies Accountant" do
      sign_in accountant
      get hr_employees_path
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
    end
  end

  describe "GET /hr/employees/:id" do
    it "allows CEO to view any record" do
      sign_in ceo
      get hr_employee_path(employee)
      expect(response).to have_http_status(:ok)
    end

    it "allows Engineer to view own record only" do
      own_employee = create(:hr_employee, user: engineer)
      sign_in engineer
      get hr_employee_path(own_employee)
      expect(response).to have_http_status(:ok)

      get hr_employee_path(employee) # someone else’s record
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
    end

    it "allows QS to view own record only" do
      own_employee = create(:hr_employee, user: qs)
      sign_in qs
      get hr_employee_path(own_employee)
      expect(response).to have_http_status(:ok)

      get hr_employee_path(employee)
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
    end

    it "allows Storekeeper to view own record only" do
      own_employee = create(:hr_employee, user: storekeeper)
      sign_in storekeeper
      get hr_employee_path(own_employee)
      expect(response).to have_http_status(:ok)

      get hr_employee_path(employee)
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
    end

    it "allows Accountant to view own record only" do
      own_employee = create(:hr_employee, user: accountant)
      sign_in accountant
      get hr_employee_path(own_employee)
      expect(response).to have_http_status(:ok)

      get hr_employee_path(employee)
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
    end
  end

  describe "POST /hr/employees" do
    context "as HR" do
      it "creates a new employee" do
        sign_in hr_user
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

    context "as Engineer" do
      it "is not authorized" do
        sign_in engineer
        post hr_employees_path, params: { hr_employee: { department: "Eng Dept" } }
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
      end
    end

    context "as CTO" do
      it "is not authorized" do
        sign_in cto
        post hr_employees_path, params: { hr_employee: { department: "CTO Dept" } }
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
      end
    end

    context "as Manager" do
      it "is not authorized" do
        sign_in site_manager
        post hr_employees_path, params: { hr_employee: { department: "Mgr Dept" } }
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
      end
    end
  end

  describe "PATCH /hr/employees/:id" do
    context "as HR" do
      it "updates the employee" do
        sign_in hr_user
        patch hr_employee_path(employee), params: { hr_employee: { department: "Updated Dept" } }
        expect(response).to redirect_to(hr_employees_path)
        expect(employee.reload.department).to eq("Updated Dept")
      end
    end

    context "as Engineer" do
      it "is not authorized" do
        sign_in engineer
        patch hr_employee_path(employee), params: { hr_employee: { department: "Updated Dept" } }
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
      end
    end

    context "as Manager" do
      it "is not authorized" do
        sign_in site_manager
        patch hr_employee_path(employee), params: { hr_employee: { department: "Updated Dept" } }
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
      end
    end
  end

  describe "DELETE /hr/employees/:id" do
    context "as CEO" do
      it "destroys the employee" do
        sign_in ceo
        expect {
          delete hr_employee_path(employee)
        }.to change(Hr::Employee, :count).by(-1)
        expect(response).to redirect_to(hr_employees_path)
      end
    end

    context "as Admin" do
      it "destroys the employee" do
        sign_in admin
        expect {
          delete hr_employee_path(employee)
        }.to change(Hr::Employee, :count).by(-1)
        expect(response).to redirect_to(hr_employees_path)
      end
    end

    context "as HR" do
      it "destroys the employee" do
        sign_in hr_user
        expect {
          delete hr_employee_path(employee)
        }.to change(Hr::Employee, :count).by(-1)
        expect(response).to redirect_to(hr_employees_path)
      end
    end

    context "as Engineer" do
      it "is not authorized" do
        sign_in engineer
        delete hr_employee_path(employee)
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
      end
    end

    context "as Manager" do
      it "is not authorized" do
        sign_in site_manager
        delete hr_employee_path(employee)
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(hr_employees_path)
      end
    end
  end
end
