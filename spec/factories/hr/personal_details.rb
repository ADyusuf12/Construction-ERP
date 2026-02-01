FactoryBot.define do
  factory :personal_detail, class: "Hr::PersonalDetail" do
    association :employee, factory: :hr_employee

    first_name             { "Test" }
    last_name              { "User" }
    dob                    { 25.years.ago.to_date }
    gender                 { :male }
    marital_status         { :single }
    means_of_identification { :nin }

    bank_name              { "Test Bank" }
    account_number         { "1234567890" }
    account_name           { "Test User" }
  end
end
