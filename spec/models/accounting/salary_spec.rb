require 'rails_helper'

RSpec.describe Accounting::Salary, type: :model do
  describe "math logic" do
    let(:salary) { create(:accounting_salary, base_pay: 100000, allowances: 20000) }

    it "calculates net_pay correctly on initialization" do
      # 100k + 20k - 0 deductions
      expect(salary.net_pay).to eq(120000)
    end

    it "recalculates net_pay when base_pay is updated" do
      salary.update!(base_pay: 150000)
      expect(salary.net_pay).to eq(170000)
    end

    it "recalculates net_pay when a deduction is added" do
      create(:accounting_deduction, salary: salary, amount: 10000)
      # This triggers salary.save via Deduction's after_commit
      salary.reload
      expect(salary.deductions_total).to eq(10000)
      expect(salary.net_pay).to eq(110000)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:base_pay) }
    it { is_expected.to validate_numericality_of(:base_pay).is_greater_than_or_equal_to(0) }
  end
end
