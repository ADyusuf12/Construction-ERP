FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@hamzis.com" }
    password { "password" }

    # Superuser admin — no employee association
    trait :admin do
      role { :admin }
    end

    # Staff roles — always attach an employee
    trait :ceo do
      role { :ceo }
      after(:build) { |u| u.employee ||= build(:hr_employee, user: u) }
    end

    trait :cto do
      role { :cto }
      after(:build) { |u| u.employee ||= build(:hr_employee, user: u) }
    end

    trait :qs do
      role { :qs }
      after(:build) { |u| u.employee ||= build(:hr_employee, user: u) }
    end

    trait :site_manager do
      role { :site_manager }
      after(:build) { |u| u.employee ||= build(:hr_employee, user: u) }
    end

    trait :engineer do
      role { :engineer }
      after(:build) { |u| u.employee ||= build(:hr_employee, user: u) }
    end

    trait :storekeeper do
      role { :storekeeper }
      after(:build) { |u| u.employee ||= build(:hr_employee, user: u) }
    end

    trait :hr do
      role { :hr }
      after(:build) { |u| u.employee ||= build(:hr_employee, user: u) }
    end

    trait :accountant do
      role { :accountant }
      after(:build) { |u| u.employee ||= build(:hr_employee, user: u) }
    end

    # Client role — attaches a Business::Client
    trait :client do
      role { :client }
      after(:build) { |u| u.client ||= build(:business_client, user: u) }
    end
  end
end
