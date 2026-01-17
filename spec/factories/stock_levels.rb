FactoryBot.define do
  factory :stock_level do
    inventory_item
    warehouse
    quantity { 10 }
  end
end
