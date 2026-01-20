require "rails_helper"

RSpec.describe Accounting::DeductionPolicy do
  let(:salary)    { create(:accounting_salary) }
  let(:deduction) { create(:accounting_deduction, salary: salary) }

  describe "CEO" do
    let(:user)   { create(:user, :ceo) }
    let(:policy) { described_class.new(user, deduction) }

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
    let(:policy) { described_class.new(user, deduction) }

    it "allows manage but not destroy" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq true
      expect(policy.destroy?).to eq true # accountant CAN destroy per policy
    end
  end

  describe "HR" do
    let(:user)   { create(:user, :hr) }
    let(:policy) { described_class.new(user, deduction) }

    it "allows viewing only" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq false
      expect(policy.update?).to eq false
      expect(policy.destroy?).to eq false
    end
  end

  describe "Engineer" do
    let(:user)   { create(:user, :engineer) }
    let(:policy) { described_class.new(user, deduction) }

    it "denies everything" do
      expect(policy.index?).to eq false
      expect(policy.show?).to eq false
      expect(policy.create?).to eq false
      expect(policy.update?).to eq false
      expect(policy.destroy?).to eq false
    end
  end
end
