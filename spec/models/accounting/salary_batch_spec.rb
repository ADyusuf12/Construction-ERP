require 'rails_helper'

RSpec.describe Accounting::SalaryBatch, type: :model do
  # Clean slate for every test in this file
  before(:each) do
    Accounting::Deduction.delete_all
    Accounting::Salary.delete_all
    Accounting::SalaryBatch.delete_all
    Hr::RecurringAdjustment.delete_all
    Hr::Employee.delete_all
  end

  describe "callbacks" do
    it "automatically populates salaries for active employees on create" do
      # Create 2 employees manually to avoid factory associations triggering extras
      2.times do |i|
        Hr::Employee.create!(
          staff_id: "TEST#{i}",
          department: "Eng",
          position_title: "Staff",
          status: :active,
          base_salary: 50000,
          hire_date: Date.today
        )
      end

      batch = Accounting::SalaryBatch.new(
        name: "Test Batch",
        period_start: Date.today,
        period_end: Date.today.end_of_month
      )

      expect { batch.save }.to change(Accounting::Salary, :count).by(2)
    end

    it "applies recurring adjustments accurately" do
      emp = Hr::Employee.create!(
        staff_id: "ADJ01",
        department: "Fin",
        position_title: "Manager",
        status: :active,
        base_salary: 100000,
        hire_date: Date.today
      )

      # Create 1 Allowance and 1 Deduction
      Hr::RecurringAdjustment.create!(employee: emp, label: "Travel", amount: 20000, adjustment_type: :allowance, active: true)
      Hr::RecurringAdjustment.create!(employee: emp, label: "Tax", amount: 5000, adjustment_type: :deduction, active: true)

      batch = Accounting::SalaryBatch.create!(
        name: "Adjustment Test",
        period_start: Date.today,
        period_end: Date.today.end_of_month
      )

      salary = batch.salaries.find_by(employee: emp)

      expect(salary.allowances.to_f).to eq(20000.0)
      expect(salary.deductions.count).to eq(1)
      expect(salary.net_pay.to_f).to eq(115000.0) # 100k + 20k - 5k
    end
  end
end
