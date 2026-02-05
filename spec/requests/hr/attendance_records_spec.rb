require "rails_helper"

RSpec.describe "Hr::AttendanceRecords", type: :request do
  let(:ceo)        { create(:user, :ceo) }
  let(:admin)      { create(:user, :admin) }
  let(:hr_user)    { create(:user, :hr) }
  let(:engineer)   { create(:user, :engineer) }
  let(:qs)         { create(:user, :qs) }

  let!(:hr_employee)       { create(:hr_employee, user: hr_user) }
  let!(:engineer_employee) { create(:hr_employee, user: engineer) }
  let!(:project)           { create(:project) }

  let!(:attendance_record) { create(:attendance_record, employee: hr_employee, project: project, status: :present) }

  describe "GET /hr/attendance_records" do
    it "requires login" do
      get hr_attendance_records_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows CEO" do
      sign_in ceo
      get hr_attendance_records_path
      expect(response).to have_http_status(:ok)
    end

    it "allows Admin" do
      sign_in admin
      get hr_attendance_records_path
      expect(response).to have_http_status(:ok)
    end

    it "allows HR" do
      sign_in hr_user
      get hr_attendance_records_path
      expect(response).to have_http_status(:ok)
    end

    it "denies Engineer" do
      sign_in engineer
      get hr_attendance_records_path
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(my_attendance_hr_attendance_records_path)
    end

    it "filters by status" do
      sign_in hr_user
      create(:attendance_record, employee: hr_employee, project: project,
                                         status: :late, date: Date.tomorrow)

      get hr_attendance_records_path, params: { status: "late" }
      expect(response.body).to include("late")
    end

    it "filters by invalid date gracefully" do
      sign_in hr_user
      get hr_attendance_records_path, params: { date: "not-a-date" }
      expect(flash[:alert]).to eq("Invalid date format for filter")
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /hr/attendance_records/my_attendance" do
    it "requires login" do
      get my_attendance_hr_attendance_records_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows any employee" do
      sign_in engineer
      get my_attendance_hr_attendance_records_path
      expect(response).to have_http_status(:ok)
    end

    it "denies users without employee record" do
      user_without_employee = create(:user, :client)
      sign_in user_without_employee
      get my_attendance_hr_attendance_records_path
      expect(response).to redirect_to(dashboard_home_path)
      expect(flash[:alert]).to eq("You are not linked to an employee record.")
    end
  end

  describe "POST /hr/attendance_records" do
    context "as Engineer" do
      it "creates a record for themselves only" do
        sign_in engineer
        expect {
          post hr_attendance_records_path, params: {
            attendance_record: {
              employee_id: hr_employee.id, # trying to spoof another employee
              project_id: project.id,
              date: Date.today,
              status: "present",
              check_in_time: "09:00",
              check_out_time: "17:00"
            }
          }
        }.to change(Hr::AttendanceRecord, :count).by(1)

        created = Hr::AttendanceRecord.last
        expect(created.employee).to eq(engineer_employee) # forced to own employee
        expect(response).to redirect_to(hr_attendance_record_path(created))
      end
    end

    context "as HR" do
      it "can create for any employee" do
        sign_in hr_user
        expect {
          post hr_attendance_records_path, params: {
            attendance_record: {
              employee_id: engineer_employee.id,
              project_id: project.id,
              date: Date.today,
              status: "late",
              check_in_time: "10:00",
              check_out_time: "17:00"
            }
          }
        }.to change(Hr::AttendanceRecord, :count).by(1)

        created = Hr::AttendanceRecord.last
        expect(created.employee).to eq(engineer_employee)
        expect(response).to redirect_to(hr_attendance_record_path(created))
      end
    end
  end

  describe "PATCH /hr/attendance_records/:id" do
    it "allows HR to update" do
      sign_in hr_user
      patch hr_attendance_record_path(attendance_record), params: {
        attendance_record: { status: "late", check_in_time: "10:00" }
      }
      expect(response).to redirect_to(hr_attendance_record_path(attendance_record))
      expect(attendance_record.reload.status).to eq("late")
    end

    it "denies Engineer updating someone else's record" do
      sign_in engineer
      patch hr_attendance_record_path(attendance_record), params: {
        attendance_record: { status: "absent" }
      }
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(my_attendance_hr_attendance_records_path)
      expect(attendance_record.reload.status).to eq("present")
    end
  end

  describe "DELETE /hr/attendance_records/:id" do
    it "allows HR to destroy" do
      sign_in hr_user
      expect {
        delete hr_attendance_record_path(attendance_record)
      }.to change(Hr::AttendanceRecord, :count).by(-1)
      expect(response).to redirect_to(hr_attendance_records_path)
    end

    it "denies Engineer destroying" do
      sign_in engineer
      delete hr_attendance_record_path(attendance_record)
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(my_attendance_hr_attendance_records_path)
      expect(Hr::AttendanceRecord.exists?(attendance_record.id)).to eq(true)
    end
  end
end
