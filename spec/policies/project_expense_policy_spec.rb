require "rails_helper"

RSpec.describe ProjectExpensePolicy do
  let(:project) { create(:project) }
  let(:expense) { create(:project_expense, project: project) }

  describe "CEO" do
    let(:user)   { create(:user, :ceo) }
    let(:policy) { described_class.new(user, expense) }

    it "allows all actions" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq true
      expect(policy.destroy?).to eq true
    end
  end

  describe "Accountant" do
    let(:user)   { create(:user, :accountant) }
    let(:policy) { described_class.new(user, expense) }

    it "allows manage but not destroy" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq true
      expect(policy.destroy?).to eq false
    end
  end

  describe "Engineer" do
    let(:user)   { create(:user, :engineer) }
    let(:policy) { described_class.new(user, expense) }

    it "allows viewing but not managing" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq false
      expect(policy.update?).to eq false
      expect(policy.destroy?).to eq false
    end
  end

  describe "Site Manager" do
    let(:user)   { create(:user, :site_manager) }
    let(:policy) { described_class.new(user, expense) }

    it "allows create/update but not destroy" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq true
      expect(policy.destroy?).to eq false
    end
  end

  describe "HR" do
    let(:user)   { create(:user, :hr) }
    let(:policy) { described_class.new(user, expense) }

    it "allows everything" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq true
      expect(policy.destroy?).to eq true
    end
  end

  describe "Storekeeper" do
    let(:user)   { create(:user, :storekeeper) }
    let(:policy) { described_class.new(user, expense) }

    it "allows viewing only" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq false
      expect(policy.update?).to eq false
      expect(policy.destroy?).to eq false
    end
  end
end
