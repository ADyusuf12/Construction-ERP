FactoryBot.define do
  factory :project_inventory do
    association :project
    inventory_item
    quantity_reserved { 2 }
    purpose { "reserved_for_task" }
    task { nil }
  end
end
