require "rails_helper"

RSpec.describe Hr::LeavePolicy do
  let(:employee) { create(:hr_employee) }
  let(:leave)    { create(:hr_leave, :pending, employee: employee) }

  context "as CEO" do
    let(:user) { create(:user, :ceo) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    subject { described_class.new(user, leave) }

    it "permits management actions" do
      expect(subject.index?).to be true
      expect(subject.approve?).to be true
      expect(subject.destroy?).to be true # Can delete others' pending leaves
    end
  end

  context "as Engineer (Owner)" do
    let(:user) { create(:user, :engineer) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    let(:own_leave) { create(:hr_leave, :pending, employee: own_employee) }
    let(:approved_leave) { create(:hr_leave, :approved, employee: own_employee) }

    it "permits destroying own pending leave" do
      policy = described_class.new(user, own_leave)
      expect(policy.destroy?).to be true
    end

    it "denies destroying own approved leave" do
      policy = described_class.new(user, approved_leave)
      expect(policy.destroy?).to be false
    end

    it "denies destroying others' leaves" do
      other_leave = create(:hr_leave, :pending)
      policy = described_class.new(user, other_leave)
      expect(policy.destroy?).to be false
    end
  end
end
