FactoryBot.define do
  factory :stock_movement do
    association :inventory_item
    movement_type { :inbound }
    quantity { 5 }
    unit_cost { 10.0 }

    # For inbound/adjustment we expect a destination warehouse
    association :destination_warehouse, factory: :warehouse

    employee { nil }

    trait :with_employee do
      association :employee, factory: :hr_employee
    end

    trait :outbound do
      movement_type { :outbound }
      association :source_warehouse, factory: :warehouse
      association :project
    end

    trait :adjustment do
      movement_type { :adjustment }
      association :destination_warehouse, factory: :warehouse
    end

    trait :site_delivery do
      movement_type { :site_delivery }
      association :project
    end
  end
end
