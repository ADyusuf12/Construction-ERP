require "rails_helper"

RSpec.describe Hr::AttendanceRecordPolicy do
  let(:employee) { create(:hr_employee) }
  let(:record)   { create(:attendance_record, employee: employee) }

  context "as CEO" do
    let(:user) { create(:user, :ceo) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    subject { described_class.new(user, record) }

    it "permits index, my_attendance, show, create, update, destroy" do
      expect(subject.index?).to eq(true)
      expect(subject.my_attendance?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as Admin" do
    let(:user) { create(:user, :admin) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    subject { described_class.new(user, record) }

    it "permits index, my_attendance, show, create, update, destroy" do
      expect(subject.index?).to eq(true)
      expect(subject.my_attendance?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as HR" do
    let(:user) { create(:user, :hr) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    subject { described_class.new(user, record) }

    it "permits index, my_attendance, show, create, update, destroy" do
      expect(subject.index?).to eq(true)
      expect(subject.my_attendance?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as Site Manager" do
    let(:user) { create(:user, :site_manager) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    let!(:subordinate)  { create(:hr_employee, manager: own_employee) }
    let!(:sub_record)   { create(:attendance_record, employee: subordinate) }

    it "denies index but permits my_attendance" do
      policy = described_class.new(user, record)
      expect(policy.index?).to eq(false)
      expect(policy.my_attendance?).to eq(true)
    end

    it "permits show/update of subordinate records" do
      sub_policy = described_class.new(user, sub_record)
      expect(sub_policy.show?).to eq(true)
      expect(sub_policy.update?).to eq(true)
    end

    it "permits show/update of own records" do
      own_record = create(:attendance_record, employee: own_employee)
      own_policy = described_class.new(user, own_record)
      expect(own_policy.show?).to eq(true)
      expect(own_policy.update?).to eq(true)
    end

    it "denies destroy" do
      sub_policy = described_class.new(user, sub_record)
      expect(sub_policy.destroy?).to eq(false)
    end
  end

  context "as Regular Employee" do
    let(:user) { create(:user, :engineer) }
    let!(:own_employee) { create(:hr_employee, user: user) }
    let!(:own_record)   { create(:attendance_record, employee: own_employee) }

    it "denies index but permits my_attendance" do
      policy = described_class.new(user, record)
      expect(policy.index?).to eq(false)
      expect(policy.my_attendance?).to eq(true)
    end

    it "permits show/update of own record only" do
      own_policy = described_class.new(user, own_record)
      expect(own_policy.show?).to eq(true)
      expect(own_policy.update?).to eq(true)

      other_policy = described_class.new(user, record)
      expect(other_policy.show?).to eq(false)
      expect(other_policy.update?).to eq(false)
    end

    it "permits create but denies destroy" do
      policy = described_class.new(user, own_record)
      expect(policy.create?).to eq(true)
      expect(policy.destroy?).to eq(false)
    end
  end
end
