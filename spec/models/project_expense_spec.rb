require "rails_helper"

RSpec.describe ProjectExpense, type: :model do
  let(:project) { create(:project) }

  describe "associations" do
    it { is_expected.to belong_to(:project).optional }
    it { is_expected.to belong_to(:stock_movement).optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  end

  describe "scopes" do
    let!(:older) { create(:project_expense, project: project, date: 5.days.ago) }
    let!(:newer) { create(:project_expense, project: project, date: 1.day.ago) }

    it "orders recent expenses by date descending" do
      expect(ProjectExpense.recent.first).to eq(newer)
    end

    it "returns only active expenses" do
      active = create(:project_expense, project: project, amount: 100)
      cancelled = create(:project_expense, project: project, amount: 0)
      expect(ProjectExpense.active).to include(active)
      expect(ProjectExpense.active).not_to include(cancelled)
    end
  end

  describe "#cancel!" do
    let(:expense) { create(:project_expense, project: project, description: "Test Expense", amount: 200) }

    it "sets amount to 0 and updates description" do
      expense.cancel!(reason: "Duplicate entry")
      expect(expense.amount).to eq(0)
      expect(expense.description).to include("Cancelled: Duplicate entry")
    end

    it "marks expense as cancelled" do
      expense.cancel!
      expect(expense.cancelled?).to be true
    end
  end
end
