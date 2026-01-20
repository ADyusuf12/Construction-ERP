FactoryBot.define do
  factory :accounting_salary, class: "Accounting::Salary" do
    association :employee, factory: :hr_employee
    association :batch,    factory: :accounting_salary_batch

    base_pay    { 1000.0 }
    allowances  { 200.0 }
    status      { :pending }
    net_pay     { base_pay + allowances } # model recalculates anyway

    trait :paid do
      status { :paid }
    end

    trait :failed do
      status { :failed }
    end
  end
end
