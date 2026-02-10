# --- Warehouses ---
warehouse1 = Warehouse.create!(name: "Central Depot Abuja", code: "ABJ001", address: "Plot 12, Garki, Abuja")
warehouse2 = Warehouse.create!(name: "Lagos Warehouse", code: "LAG001", address: "Industrial Layout, Lagos")

# --- Inventory Items ---
cement = InventoryItem.create!(sku: "CEM001", name: "Cement (50kg bag)", unit_cost: 4500, reorder_threshold: 100, unit: "bags")
steel_rods = InventoryItem.create!(sku: "STL001", name: "Steel Rods (12mm)", unit_cost: 3500, reorder_threshold: 200, unit: "pieces")
roofing_sheets = InventoryItem.create!(sku: "ROF001", name: "Roofing Sheets", unit_cost: 8000, reorder_threshold: 50, unit: "sheets")
electrical_cables = InventoryItem.create!(sku: "CAB001", name: "Electrical Cables (100m roll)", unit_cost: 12000, reorder_threshold: 30, unit: "rolls")

# --- Stock Levels ---
StockLevel.create!(inventory_item: cement, warehouse: warehouse1, quantity: 500)
StockLevel.create!(inventory_item: steel_rods, warehouse: warehouse1, quantity: 300)
StockLevel.create!(inventory_item: roofing_sheets, warehouse: warehouse2, quantity: 80)
StockLevel.create!(inventory_item: electrical_cables, warehouse: warehouse2, quantity: 20)

# --- Stock Movements ---
StockMovement.create!(
  inventory_item: cement,
  destination_warehouse: warehouse1,
  employee: Hr::Employee.joins(:user).find_by(users: { email: "storekeeper@hamzis.com" }),
  movement_type: :inbound,
  quantity: 200,
  unit_cost: 4500,
  reference: "Supplier Delivery",
  notes: "Delivered by Dangote Cement"
)

StockMovement.create!(
  inventory_item: steel_rods,
  source_warehouse: warehouse1,
  employee: Hr::Employee.joins(:user).find_by(users: { email: "engineer@hamzis.com" }),
  project: Project.find_by(name: "Headquarters Construction"),
  movement_type: :outbound,
  quantity: 50,
  unit_cost: 3500,
  reference: "Issued to site",
  notes: "Used for structural framing"
)

StockMovement.create!(
  inventory_item: roofing_sheets,
  source_warehouse: warehouse2,
  employee: Hr::Employee.joins(:user).find_by(users: { email: "site_manager@hamzis.com" }),
  project: Project.find_by(name: "Warehouse Expansion"),
  movement_type: :outbound,
  quantity: 20,
  unit_cost: 8000,
  reference: "Issued to site",
  notes: "Roof installation started"
)

puts "Seeded warehouses, inventory items, stock levels, and stock movements."
