require "rails_helper"

RSpec.describe Accounting::SalaryBatchPolicy do
  let(:batch) { create(:accounting_salary_batch) }

  describe "CEO" do
    let(:user)   { create(:user, :ceo) }
    let(:policy) { described_class.new(user, batch) }

    it "allows all actions" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq true
      expect(policy.destroy?).to eq true
      expect(policy.mark_paid?).to eq true
    end
  end

  describe "Accountant" do
    let(:user)   { create(:user, :accountant) }
    let(:policy) { described_class.new(user, batch) }

    it "allows manage but not destroy" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq true
      expect(policy.destroy?).to eq false
      expect(policy.mark_paid?).to eq true
    end
  end

  describe "HR" do
    let(:user)   { create(:user, :hr) }
    let(:policy) { described_class.new(user, batch) }

    it "allows viewing only" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq false
      expect(policy.update?).to eq false
      expect(policy.destroy?).to eq false
      expect(policy.mark_paid?).to eq false
    end
  end

  describe "Engineer" do
    let(:user)   { create(:user, :engineer) }
    let(:policy) { described_class.new(user, batch) }

    it "denies everything" do
      expect(policy.index?).to eq false
      expect(policy.show?).to eq false
      expect(policy.create?).to eq false
      expect(policy.update?).to eq false
      expect(policy.destroy?).to eq false
      expect(policy.mark_paid?).to eq false
    end
  end
end
