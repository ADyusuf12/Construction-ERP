require "rails_helper"

RSpec.describe "Projects", type: :request do
  let(:cto)      { create(:user, :cto) }
  let(:manager)  { create(:user, :manager) }
  let(:qs)       { create(:user, :qs) }
  let(:engineer) { create(:user, :engineer) }

  let!(:project) { create(:project, user: cto) }

  describe "GET /projects" do
    it "requires login" do
      get projects_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows logged in users" do
      sign_in manager
      get projects_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /projects/:id" do
    context "as CTO" do
      it "destroys the project" do
        sign_in cto
        expect {
          delete project_path(project)
        }.to change(Project, :count).by(-1)

        expect(response).to redirect_to(projects_path)
        follow_redirect!
        expect(response.body).to include("Project was successfully destroyed.")
      end
    end

    context "as Manager" do
      it "is not authorized" do
        sign_in manager
        delete project_path(project)

        expect(response).to redirect_to(root_path).or redirect_to(projects_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end

    context "as QS" do
      it "is not authorized" do
        sign_in qs
        delete project_path(project)

        expect(response).to redirect_to(root_path).or redirect_to(projects_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end

    context "as Engineer" do
      it "is not authorized" do
        sign_in engineer
        delete project_path(project)

        expect(response).to redirect_to(root_path).or redirect_to(projects_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end
  end
end
