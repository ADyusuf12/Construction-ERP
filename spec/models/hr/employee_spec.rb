require 'rails_helper'

RSpec.describe Hr::Employee, type: :model do
  describe "associations" do
    it "can belong to a user (optional)" do
      user = create(:user)
      employee = create(:hr_employee, user: user)
      expect(employee.user).to eq(user)

      employee_without_user = create(:hr_employee, user: nil)
      expect(employee_without_user.user).to be_nil
    end
  end

  describe "validations" do
    it "requires department" do
      employee = build(:hr_employee, department: nil)
      expect(employee.valid?).to be false
      expect(employee.errors[:department]).to include("can't be blank")
    end

    it "requires position_title" do
      employee = build(:hr_employee, position_title: nil)
      expect(employee.valid?).to be false
      expect(employee.errors[:position_title]).to include("can't be blank")
    end

    it "requires hamzis_id if hire_date is blank" do
      employee = build(:hr_employee, hire_date: nil, hamzis_id: nil)
      expect(employee.valid?).to be false
      expect(employee.errors[:hamzis_id]).to include("can't be blank")
    end

    it "enforces uniqueness of hamzis_id" do
      first = create(:hr_employee, hamzis_id: "CUSTOM01", hire_date: Date.today)
      duplicate = build(:hr_employee, hamzis_id: "CUSTOM01", hire_date: Date.today)
      expect(duplicate.valid?).to be false
      expect(duplicate.errors[:hamzis_id]).to include("has already been taken")
      expect(first.hamzis_id).to eq("CUSTOM01")
    end
  end

  describe "status enum" do
    it "defaults to active" do
      employee = create(:hr_employee)
      expect(employee.status).to eq("active")
      expect(employee.status_active?).to be true
    end

    it "can be set to on_leave" do
      employee = create(:hr_employee, status: :on_leave)
      expect(employee.status).to eq("on_leave")
      expect(employee.status_on_leave?).to be true
    end

    it "can be set to terminated" do
      employee = create(:hr_employee, status: :terminated)
      expect(employee.status).to eq("terminated")
      expect(employee.status_terminated?).to be true
    end
  end

  describe "hamzis_id generation" do
    it "generates hamzis_id based on hire_date year if missing" do
      employee = build(:hr_employee, hamzis_id: nil, hire_date: Date.new(2025, 12, 20))
      expect(employee.hamzis_id).to be_nil

      employee.valid? # triggers before_validation
      expect(employee.hamzis_id).to match(/\A\d{3}25\z/) # e.g. "00125"
    end

    it "increments sequence for multiple hires in the same year" do
      first = create(:hr_employee, hire_date: Date.new(2025, 12, 20), hamzis_id: nil)
      second = create(:hr_employee, hire_date: Date.new(2025, 12, 21), hamzis_id: nil)
      expect(second.hamzis_id[0..2].to_i).to eq(first.hamzis_id[0..2].to_i + 1)
    end

    it "does not overwrite hamzis_id if already provided" do
      employee = create(:hr_employee, hamzis_id: "CUSTOM01", hire_date: Date.new(2025, 12, 20))
      expect(employee.hamzis_id).to eq("CUSTOM01")
    end

    it "does not generate hamzis_id if hire_date is blank" do
      employee = build(:hr_employee, hire_date: nil, hamzis_id: nil)
      employee.valid?
      expect(employee.hamzis_id).to be_nil
    end
  end
end
