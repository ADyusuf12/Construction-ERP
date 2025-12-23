# spec/policies/hr/employee_policy_spec.rb
require "rails_helper"

RSpec.describe Hr::EmployeePolicy do
  let(:employee) { create(:hr_employee) }

  context "as CEO" do
    let(:user) { create(:user, :ceo) }
    subject { described_class.new(user, employee) }

    it "permits all actions" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as Admin" do
    let(:user) { create(:user, :admin) }
    subject { described_class.new(user, employee) }

    it "permits all actions" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as HR" do
    let(:user) { create(:user, :hr) }
    subject { described_class.new(user, employee) }

    it "permits all actions" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as CTO" do
    let(:user) { create(:user, :cto) }
    subject { described_class.new(user, employee) }

    it "permits index/show but forbids create/update/destroy" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(false)
      expect(subject.update?).to eq(false)
      expect(subject.destroy?).to eq(false)
    end
  end

  context "as Manager" do
    let(:user) { create(:user, :manager) }
    subject { described_class.new(user, employee) }

    it "permits index/show but forbids create/update/destroy" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(false)
      expect(subject.update?).to eq(false)
      expect(subject.destroy?).to eq(false)
    end
  end

  context "as Engineer" do
    let(:user) { create(:user, :engineer) }
    let(:own_employee) { create(:hr_employee, user: user) }

    it "denies index" do
      policy = described_class.new(user, employee)
      expect(policy.index?).to eq(false)
    end

    it "permits show of own record only" do
      own_policy = described_class.new(user, own_employee)
      expect(own_policy.show?).to eq(true)

      other_policy = described_class.new(user, employee)
      expect(other_policy.show?).to eq(false)
    end

    it "denies create/update/destroy" do
      policy = described_class.new(user, employee)
      expect(policy.create?).to eq(false)
      expect(policy.update?).to eq(false)
      expect(policy.destroy?).to eq(false)
    end
  end

  context "as QS" do
    let(:user) { create(:user, :qs) }
    let(:own_employee) { create(:hr_employee, user: user) }

    it "denies index" do
      policy = described_class.new(user, employee)
      expect(policy.index?).to eq(false)
    end

    it "permits show of own record only" do
      own_policy = described_class.new(user, own_employee)
      expect(own_policy.show?).to eq(true)

      other_policy = described_class.new(user, employee)
      expect(other_policy.show?).to eq(false)
    end

    it "denies create/update/destroy" do
      policy = described_class.new(user, employee)
      expect(policy.create?).to eq(false)
      expect(policy.update?).to eq(false)
      expect(policy.destroy?).to eq(false)
    end
  end

  context "as Storekeeper" do
    let(:user) { create(:user, :storekeeper) }
    let(:own_employee) { create(:hr_employee, user: user) }

    it "denies index" do
      policy = described_class.new(user, employee)
      expect(policy.index?).to eq(false)
    end

    it "permits show of own record only" do
      own_policy = described_class.new(user, own_employee)
      expect(own_policy.show?).to eq(true)

      other_policy = described_class.new(user, employee)
      expect(other_policy.show?).to eq(false)
    end

    it "denies create/update/destroy" do
      policy = described_class.new(user, employee)
      expect(policy.create?).to eq(false)
      expect(policy.update?).to eq(false)
      expect(policy.destroy?).to eq(false)
    end
  end

  context "as Accountant" do
    let(:user) { create(:user, :accountant) }
    let(:own_employee) { create(:hr_employee, user: user) }

    it "denies index" do
      policy = described_class.new(user, employee)
      expect(policy.index?).to eq(false)
    end

    it "permits show of own record only" do
      own_policy = described_class.new(user, own_employee)
      expect(own_policy.show?).to eq(true)

      other_policy = described_class.new(user, employee)
      expect(other_policy.show?).to eq(false)
    end

    it "denies create/update/destroy" do
      policy = described_class.new(user, employee)
      expect(policy.create?).to eq(false)
      expect(policy.update?).to eq(false)
      expect(policy.destroy?).to eq(false)
    end
  end
end
