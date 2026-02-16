require "rails_helper"

RSpec.describe "Reports", type: :request do
  let(:project) { create(:project) }
  let(:employee) { create(:employee) }
  let(:user)    { create(:user, :ceo, employee: employee) }
  let(:report)  { create(:report, project: project, employee: employee) }

  before { sign_in user } # Devise helper

  describe "GET /reports (global index)" do
    it "returns success" do
      get reports_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /projects/:project_id/reports (scoped index)" do
    it "returns success" do
      get project_reports_path(project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /projects/:project_id/reports/:id" do
    it "returns success" do
      get project_report_path(project, report)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /projects/:project_id/reports" do
    it "creates a report" do
      expect {
        post project_reports_path(project), params: {
          report: {
            report_date: Date.today,
            report_type: "daily",
            status: "draft",
            progress_summary: "This is a valid progress summary with more than ten characters.",
            issues: "None",
            next_steps: "Continue"
          }
        }
      }.to change(Report, :count).by(1)

      new_report = Report.last
      expect(response).to redirect_to(project_report_path(project, new_report))
      expect(new_report.progress_summary).to include("valid progress summary")
    end
  end

  describe "PATCH /projects/:project_id/reports/:id/submit" do
    it "submits a draft report" do
      draft_report = create(:report, project: project, employee: user.employee, status: :draft)

      patch submit_project_report_path(project, draft_report)

      expect(response).to redirect_to(project_report_path(project, draft_report))
      expect(draft_report.reload.status).to eq("submitted")
    end
  end

  describe "PATCH /projects/:project_id/reports/:id/review" do
    it "reviews a submitted report" do
      submitted_report = create(:report, project: project, employee: user.employee, status: :submitted)

      patch review_project_report_path(project, submitted_report)

      expect(response).to redirect_to(project_report_path(project, submitted_report))
      expect(submitted_report.reload.status).to eq("reviewed")
    end
  end

  describe "DELETE /projects/:project_id/reports/:id" do
    it "deletes a report" do
      report_to_delete = create(:report, project: project, employee: employee)

      expect {
        delete project_report_path(project, report_to_delete)
      }.to change(Report, :count).by(-1)

      expect(response).to redirect_to(project_reports_path(project))
    end
  end
end
