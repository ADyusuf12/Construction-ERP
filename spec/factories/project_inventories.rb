FactoryBot.define do
  factory :project_inventory do
    association :project
    association :inventory_item
    association :warehouse

    quantity_reserved { 2 }
    purpose { "reserved_for_task" }
    task { nil }

    after(:create) do |pi|
      StockLevel.find_or_create_by!(
        inventory_item: pi.inventory_item,
        warehouse: pi.warehouse
      ).update!(quantity: 10)
    end
  end
end
