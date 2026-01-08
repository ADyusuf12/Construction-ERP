FactoryBot.define do
  factory :accounting_salary_batch, class: "Accounting::SalaryBatch" do
    name         { "January Payroll" }
    period_start { Date.today.beginning_of_month }
    period_end   { Date.today.end_of_month }
    status       { :pending }

    trait :processed do
      status { :processed }
    end

    trait :paid do
      status { :paid }
    end
  end
end
