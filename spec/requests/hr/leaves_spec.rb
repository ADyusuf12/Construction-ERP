require "rails_helper"

RSpec.describe "Hr::Leaves", type: :request do
  let(:ceo)        { create(:user, :ceo) }
  let(:admin)      { create(:user, :admin) }
  let(:hr_user)    { create(:user, :hr) }
  let(:engineer)   { create(:user, :engineer) }
  let(:qs)         { create(:user, :qs) }
  let(:storekeeper) { create(:user, :storekeeper) }
  let(:accountant) { create(:user, :accountant) }

  let!(:hr_employee)       { create(:hr_employee, user: hr_user) }
  let!(:engineer_employee) { create(:hr_employee, user: engineer) }
  let!(:leave)             { create(:hr_leave, employee: hr_employee) }

  describe "GET /hr/leaves" do
    it "requires login" do
      get hr_leaves_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows CEO" do
      sign_in ceo
      get hr_leaves_path
      expect(response).to have_http_status(:ok)
    end

    it "allows Admin" do
      sign_in admin
      get hr_leaves_path
      expect(response).to have_http_status(:ok)
    end

    it "allows HR" do
      sign_in hr_user
      get hr_leaves_path
      expect(response).to have_http_status(:ok)
    end

    it "denies Engineer" do
      sign_in engineer
      get hr_leaves_path
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(my_leaves_hr_leaves_path)
    end
  end

  describe "GET /hr/leaves/my_leaves" do
    it "allows any employee" do
      sign_in engineer
      get my_leaves_hr_leaves_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /hr/leaves" do
    context "as Engineer" do
      it "creates a new leave and redirects to my_leaves" do
        sign_in engineer
        expect {
          post hr_leaves_path, params: {
            hr_leave: {
              start_date: Date.today,
              end_date: Date.today + 3.days,
              reason: "Vacation"
            }
          }
        }.to change(Hr::Leave, :count).by(1)

        expect(response).to redirect_to(my_leaves_hr_leaves_path)
      end
    end

    context "as HR" do
      it "creates a new leave and redirects to my_leaves" do
        sign_in hr_user
        expect {
          post hr_leaves_path, params: {
            hr_leave: {
              start_date: Date.today,
              end_date: Date.today + 2.days,
              reason: "Conference"
            }
          }
        }.to change(Hr::Leave, :count).by(1)

        expect(response).to redirect_to(my_leaves_hr_leaves_path)
      end
    end
  end

  describe "PATCH /hr/leaves/:id/approve" do
    it "allows HR to approve someone else's leave" do
      other_employee = create(:hr_employee)
      other_leave    = create(:hr_leave, employee: other_employee)

      sign_in hr_user
      patch approve_hr_leave_path(other_leave)
      expect(response).to redirect_to(hr_leaves_path)
      expect(other_leave.reload.status).to eq("approved")
    end

    it "denies Engineer" do
      sign_in engineer
      patch approve_hr_leave_path(leave)
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(my_leaves_hr_leaves_path)
      expect(leave.reload.status).to eq("pending")
    end
  end

  describe "PATCH /hr/leaves/:id/reject" do
    it "allows Admin to reject" do
      other_employee = create(:hr_employee)
      other_leave    = create(:hr_leave, employee: other_employee)

      sign_in admin
      patch reject_hr_leave_path(other_leave)
      expect(response).to redirect_to(hr_leaves_path)
      expect(other_leave.reload.status).to eq("rejected")
    end

    it "denies QS" do
      sign_in qs
      patch reject_hr_leave_path(leave)
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(my_leaves_hr_leaves_path)
      expect(leave.reload.status).to eq("pending")
    end
  end

  describe "PATCH /hr/leaves/:id/cancel" do
    it "allows owner to cancel" do
      sign_in hr_user
      patch cancel_hr_leave_path(leave)
      expect(response).to redirect_to(my_leaves_hr_leaves_path)
      expect(leave.reload.status).to eq("cancelled")
    end

    it "denies other employee" do
      sign_in engineer
      patch cancel_hr_leave_path(leave)
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(my_leaves_hr_leaves_path)
      expect(leave.reload.status).to eq("pending")
    end
  end
end
