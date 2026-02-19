# 1. Fetch Key Actors & Projects
storekeeper = Hr::Employee.joins(:user).find_by!(users: { email: "storekeeper@example.com" })
engineer    = Hr::Employee.joins(:user).find_by!(users: { email: "engineer@example.com" })
site_mgr    = Hr::Employee.joins(:user).find_by!(users: { email: "site_manager@example.com" })

project_hq     = Project.find_by!(name: "Abuja HQ Tower Construction")
project_lagos  = Project.find_by!(name: "Lagos Warehouse Expansion")

# --- Warehouses ---
warehouse1 = Warehouse.find_or_create_by!(code: "ABJ001") do |w|
  w.name = "Central Depot Abuja"
  w.address = "Plot 12, Garki, Abuja"
end

warehouse2 = Warehouse.find_or_create_by!(code: "LAG001") do |w|
  w.name = "Lagos Warehouse"
  w.address = "Industrial Layout, Lagos"
end

# --- Inventory Items (Enriched with 2 more items) ---
cement = InventoryItem.find_or_create_by!(sku: "CEM001") do |i|
  i.update(name: "Cement (50kg bag)", unit_cost: 4500, reorder_threshold: 100, unit: "bags")
end

steel_rods = InventoryItem.find_or_create_by!(sku: "STL001") do |i|
  i.update(name: "Steel Rods (12mm)", unit_cost: 3500, reorder_threshold: 200, unit: "pieces")
end

roofing_sheets = InventoryItem.find_or_create_by!(sku: "ROF001") do |i|
  i.update(name: "Roofing Sheets", unit_cost: 8000, reorder_threshold: 50, unit: "sheets")
end

electrical_cables = InventoryItem.find_or_create_by!(sku: "CAB001") do |i|
  i.update(name: "Electrical Cables (100m roll)", unit_cost: 12000, reorder_threshold: 30, unit: "rolls")
end

# NEW ITEM 1: Finishing Materials
floor_tiles = InventoryItem.find_or_create_by!(sku: "TILE-60") do |i|
  i.update(name: "Ceramic Floor Tiles (60x60)", unit_cost: 7500, reorder_threshold: 40, unit: "boxes")
end

# NEW ITEM 2: Paints
emulsion_paint = InventoryItem.find_or_create_by!(sku: "PNT-WHT") do |i|
  i.update(name: "White Emulsion Paint (20L)", unit_cost: 18500, reorder_threshold: 10, unit: "drums")
end

# --- Stock Levels (The Current Snapshot) ---
StockLevel.find_or_create_by!(inventory_item: cement, warehouse: warehouse1).update!(quantity: 500)
StockLevel.find_or_create_by!(inventory_item: steel_rods, warehouse: warehouse1).update!(quantity: 300)
StockLevel.find_or_create_by!(inventory_item: floor_tiles, warehouse: warehouse1).update!(quantity: 150)

StockLevel.find_or_create_by!(inventory_item: roofing_sheets, warehouse: warehouse2).update!(quantity: 80)
StockLevel.find_or_create_by!(inventory_item: electrical_cables, warehouse: warehouse2).update!(quantity: 20) # Trigger Alert
StockLevel.find_or_create_by!(inventory_item: emulsion_paint, warehouse: warehouse2).update!(quantity: 5)   # Trigger Alert

# --- Stock Movements (The Ledger) ---

# 1. Inbound to Abuja
StockMovement.create!(
  inventory_item: cement,
  destination_warehouse: warehouse1,
  employee: storekeeper,
  movement_type: :inbound,
  quantity: 200,
  unit_cost: 4500,
  reference: "SUP-DANG-001",
  notes: "Delivered by Dangote Cement"
)

# 2. Outbound from Abuja to HQ Project
StockMovement.create!(
  inventory_item: steel_rods,
  source_warehouse: warehouse1,
  employee: engineer,
  project: project_hq,
  movement_type: :outbound,
  quantity: 50,
  unit_cost: 3500,
  reference: "REQ-HQ-001",
  notes: "Used for structural framing"
)

# 3. Inter-Warehouse Move (Any warehouse can be source/destination)
# Moving Tiles from Abuja to Lagos
StockMovement.create!(
  inventory_item: floor_tiles,
  source_warehouse: warehouse1,
  destination_warehouse: warehouse2,
  employee: storekeeper,
  movement_type: :outbound,
  quantity: 50,
  reference: "XFR-ABJ-LAG-01",
  notes: "Stock re-balancing for finishing phase in Lagos"
)

# 4. Outbound from Lagos to Warehouse Expansion Project
StockMovement.create!(
  inventory_item: roofing_sheets,
  source_warehouse: warehouse2,
  employee: site_mgr,
  project: project_lagos,
  movement_type: :outbound,
  quantity: 20,
  unit_cost: 8000,
  reference: "REQ-LAG-002",
  notes: "Roof installation started"
)

puts "Seeded 2 Warehouses, 6 Inventory Items with StockLevels, and complex StockMovements."
