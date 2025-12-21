FactoryBot.define do
  factory :hr_employee, class: 'Hr::Employee' do
    hamzis_id { "MyString" }
    department { "MyString" }
    position_title { "MyString" }
    hire_date { "2025-12-20" }
    status { 1 }
    leave_balance { 1 }
    performance_score { "9.99" }
    user { nil }
  end
end
