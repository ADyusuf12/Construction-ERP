FactoryBot.define do
  factory :next_of_kin, class: "Hr::NextOfKin" do
    association :employee, factory: :hr_employee
    name { "John Doe" }
    relationship { "Brother" }
    phone_number { "08012345678" }
    address { "123 Main Street, Abuja" }
  end
end
