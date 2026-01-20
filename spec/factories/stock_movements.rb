FactoryBot.define do
  factory :stock_movement do
    inventory_item
    warehouse
    movement_type { :inbound }
    quantity { 5 }
    unit_cost { 10.0 }

    employee { nil }

    trait :with_employee do
      association :employee, factory: :hr_employee
    end

    trait :outbound do
      movement_type { :outbound }
    end

    trait :adjustment do
      movement_type { :adjustment }
    end
  end
end
