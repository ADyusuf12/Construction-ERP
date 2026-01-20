FactoryBot.define do
  factory :inventory_item do
    sequence(:sku) { |n| "SKU-#{n.to_s.rjust(4, '0')}" }
    sequence(:name) { |n| "Material #{n}" }
    unit_cost { "12.50" }
    reorder_threshold { 5 }
    status { :in_stock }
  end
end
