FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }

    trait :ceo do
      role { :ceo }
    end

    trait :admin do
      role { :admin }
    end

    trait :accountant do
      role { :accountant }
    end


    trait :cto do
      role { :cto }
    end

    trait :manager do
      role { :manager }
    end

    trait :qs do
      role { :qs }
    end

    trait :engineer do
      role { :engineer }
    end
  end
end
