require 'rails_helper'

RSpec.describe Accounting::Deduction, type: :model do
  let(:salary) { create(:accounting_salary, base_pay: 100000, allowances: 0) }

  describe "parent salary integration" do
    it "triggers salary recalculation after creation" do
      create(:accounting_deduction, salary: salary, amount: 5000)
      expect(salary.reload.net_pay).to eq(95000)
    end

    it "triggers salary recalculation after update" do
      deduction = create(:accounting_deduction, salary: salary, amount: 5000)
      deduction.update!(amount: 10000)
      expect(salary.reload.net_pay).to eq(90000)
    end

    it "triggers salary recalculation after destruction" do
      deduction = create(:accounting_deduction, salary: salary, amount: 5000)
      expect(salary.reload.net_pay).to eq(95000)

      deduction.destroy
      expect(salary.reload.net_pay).to eq(100000)
    end
  end
end
