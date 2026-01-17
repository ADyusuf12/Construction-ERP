require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let(:project) { create(:project) }
  let(:task)    { create(:task, project: project) }
  let(:user)    { create(:user, :ceo) }

  before { sign_in user } # because using devise

  describe "GET /tasks" do
    it "returns success" do
      get tasks_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /projects/:project_id/tasks/:id" do
    it "returns success" do
      get project_task_path(project, task)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /projects/:project_id/tasks" do
    it "creates a task" do
      expect {
        post project_tasks_path(project), params: { task: { title: "New Task", weight: 1 } }
      }.to change(Task, :count).by(1)

      new_task = Task.last
      expect(response).to redirect_to(project_task_path(project, new_task))
      expect(new_task.title).to eq("New Task")
    end
  end
end
