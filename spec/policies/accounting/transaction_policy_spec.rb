require "rails_helper"

RSpec.describe Accounting::TransactionPolicy do
  let(:project)     { create(:project) }
  let(:transaction) { create(:accounting_transaction, project: project) }

  describe "CEO" do
    let(:user)   { create(:user, :ceo) }
    let(:policy) { described_class.new(user, transaction) }

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
    let(:policy) { described_class.new(user, transaction) }

    it "allows manage but not destroy" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq true
      expect(policy.destroy?).to eq false
      expect(policy.mark_paid?).to eq true
    end
  end

  describe "Engineer" do
    let(:user)   { create(:user, :engineer) }
    let(:policy) { described_class.new(user, transaction) }

    it "allows viewing but not managing" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq false
      expect(policy.update?).to eq false
      expect(policy.destroy?).to eq false
      expect(policy.mark_paid?).to eq false
    end
  end
end
