require "rails_helper"

RSpec.describe "ProjectExpenses", type: :request do
  let(:project) { create(:project) }
  let(:expense) { create(:project_expense, project: project) }
  let(:user)    { create(:user, :ceo) } # CEO has full permissions

  before { sign_in user, scope: :user }

  describe "GET /project_expenses" do
    it "returns success" do
      get project_expenses_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /project_expenses/:id" do
    it "returns success" do
      get project_expense_path(expense)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /projects/:project_id/project_expenses/new" do
    it "returns success" do
      get new_project_project_expense_path(project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /project_expenses" do
    context "with valid params" do
      it "creates a global expense" do
        expect {
          post project_expenses_path, params: {
            project_expense: {
              project_id: project.id,
              date: Date.today,
              description: "Global Expense",
              amount: 1000
            }
          }
        }.to change(ProjectExpense, :count).by(1)

        expect(response).to redirect_to(project_expenses_path)
        expect(ProjectExpense.last.description).to eq("Global Expense")
      end

      it "creates a nested expense" do
        expect {
          post project_project_expenses_path(project), params: {
            project_expense: {
              date: Date.today,
              description: "Nested Expense",
              amount: 500
            }
          }
        }.to change(ProjectExpense, :count).by(1)

        expect(response).to redirect_to(project_path(project))
        expect(ProjectExpense.last.project).to eq(project)
      end
    end

    context "with invalid params" do
      it "does not create an expense" do
        expect {
          post project_expenses_path, params: {
            project_expense: {
              date: nil,
              description: "",
              amount: -10
            }
          }
        }.not_to change(ProjectExpense, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /project_expenses/:id" do
    it "updates an expense" do
      patch project_expense_path(expense), params: {
        project_expense: { description: "Updated Expense" }
      }
      expect(response).to redirect_to(project_path(project))
      expect(expense.reload.description).to eq("Updated Expense")
    end
  end

  describe "DELETE /project_expenses/:id" do
    it "deletes an expense" do
      expense # ensure created
      expect {
        delete project_expense_path(expense)
      }.to change(ProjectExpense, :count).by(-1)

      expect(response).to redirect_to(project_path(project))
    end
  end
end
