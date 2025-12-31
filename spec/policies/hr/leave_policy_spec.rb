require "rails_helper"

RSpec.describe Hr::LeavePolicy do
  let(:employee) { create(:hr_employee) }
  let(:leave)    { create(:hr_leave, employee: employee) }

  context "as CEO" do
    let(:user) { create(:user, :ceo) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    subject { described_class.new(user, leave) }

    it "permits index, my_leaves, show, create, approve/reject but not cancel own" do
      expect(subject.index?).to eq(true)
      expect(subject.my_leaves?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.approve?).to eq(true)
      expect(subject.reject?).to eq(true)
      expect(subject.cancel?).to eq(false)
    end
  end

  context "as Admin" do
    let(:user) { create(:user, :admin) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    subject { described_class.new(user, leave) }

    it "permits index, my_leaves, show, create, approve/reject but not cancel own" do
      expect(subject.index?).to eq(true)
      expect(subject.my_leaves?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.approve?).to eq(true)
      expect(subject.reject?).to eq(true)
      expect(subject.cancel?).to eq(false)
    end
  end

  context "as HR" do
    let(:user) { create(:user, :hr) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    subject { described_class.new(user, leave) }

    it "permits index, my_leaves, show, create, approve/reject but not cancel own" do
      expect(subject.index?).to eq(true)
      expect(subject.my_leaves?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.approve?).to eq(true)
      expect(subject.reject?).to eq(true)
      expect(subject.cancel?).to eq(false)
    end
  end

  context "as Engineer" do
    let(:user) { create(:user, :engineer) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    let!(:own_leave)    { create(:hr_leave, employee: own_employee) }

    it "denies index but permits my_leaves" do
      policy = described_class.new(user, leave)
      expect(policy.index?).to eq(false)
      expect(policy.my_leaves?).to eq(true)
    end

    it "permits show/cancel of own leave only" do
      own_policy = described_class.new(user, own_leave)
      expect(own_policy.show?).to eq(true)
      expect(own_policy.cancel?).to eq(true)

      other_policy = described_class.new(user, leave)
      expect(other_policy.show?).to eq(false)
      expect(other_policy.cancel?).to eq(false)
    end

    it "permits create but denies approve/reject" do
      policy = described_class.new(user, leave)
      expect(policy.create?).to eq(true)
      expect(policy.approve?).to eq(false)
      expect(policy.reject?).to eq(false)
    end
  end

  context "as QS" do
    let(:user) { create(:user, :qs) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    let!(:own_leave)    { create(:hr_leave, employee: own_employee) }

    it "denies index but permits my_leaves" do
      policy = described_class.new(user, leave)
      expect(policy.index?).to eq(false)
      expect(policy.my_leaves?).to eq(true)
    end

    it "permits show/cancel of own leave only" do
      own_policy = described_class.new(user, own_leave)
      expect(own_policy.show?).to eq(true)
      expect(own_policy.cancel?).to eq(true)

      other_policy = described_class.new(user, leave)
      expect(other_policy.show?).to eq(false)
      expect(other_policy.cancel?).to eq(false)
    end

    it "permits create but denies approve/reject" do
      policy = described_class.new(user, leave)
      expect(policy.create?).to eq(true)
      expect(policy.approve?).to eq(false)
      expect(policy.reject?).to eq(false)
    end
  end

  context "as Storekeeper" do
    let(:user) { create(:user, :storekeeper) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    let!(:own_leave)    { create(:hr_leave, employee: own_employee) }

    it "denies index but permits my_leaves" do
      policy = described_class.new(user, leave)
      expect(policy.index?).to eq(false)
      expect(policy.my_leaves?).to eq(true)
    end

    it "permits show/cancel of own leave only" do
      own_policy = described_class.new(user, own_leave)
      expect(own_policy.show?).to eq(true)
      expect(own_policy.cancel?).to eq(true)

      other_policy = described_class.new(user, leave)
      expect(other_policy.show?).to eq(false)
      expect(other_policy.cancel?).to eq(false)
    end

    it "permits create but denies approve/reject" do
      policy = described_class.new(user, leave)
      expect(policy.create?).to eq(true)
      expect(policy.approve?).to eq(false)
      expect(policy.reject?).to eq(false)
    end
  end

  context "as Accountant" do
    let(:user) { create(:user, :accountant) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    let!(:own_leave)    { create(:hr_leave, employee: own_employee) }

    it "denies index but permits my_leaves" do
      policy = described_class.new(user, leave)
      expect(policy.index?).to eq(false)
      expect(policy.my_leaves?).to eq(true)
    end

    it "permits show/cancel of own leave only" do
      own_policy = described_class.new(user, own_leave)
      expect(own_policy.show?).to eq(true)
      expect(own_policy.cancel?).to eq(true)

      other_policy = described_class.new(user, leave)
      expect(other_policy.show?).to eq(false)
      expect(other_policy.cancel?).to eq(false)
    end

    it "permits create but denies approve/reject" do
      policy = described_class.new(user, leave)
      expect(policy.create?).to eq(true)
      expect(policy.approve?).to eq(false)
      expect(policy.reject?).to eq(false)
    end
  end
end
