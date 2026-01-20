# Inventory Module Guide

This guide provides comprehensive documentation for the Inventory module, which manages warehouse operations, stock tracking, and inventory allocation for projects in the Hamzis Systems application.

## Table of Contents

- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Data Models](#data-models)
- [Features & Workflows](#features--workflows)
- [User Roles & Permissions](#user-roles--permissions)
- [API Endpoints](#api-endpoints)
- [Best Practices](#best-practices)

---

## Overview

The Inventory module manages all physical inventory operations within the organization, including:

- **Warehouse Management:** Manage multiple warehouse locations
- **Inventory Items:** Master data for all products/materials
- **Stock Levels:** Real-time tracking of quantities per warehouse
- **Stock Movements:** Complete audit trail of all inventory transactions
- **Project Allocation:** Reserve and track inventory for specific projects
- **Reorder Management:** Automatic status updates based on stock levels

### Core Responsibilities

1. **Warehouses:** Define physical storage locations
2. **Items:** Create and maintain inventory item catalog
3. **Stock Tracking:** Monitor quantities across locations
4. **Movements:** Record every inventory transaction with audit trail
5. **Allocation:** Link inventory to projects and tasks

---

## Key Concepts

### Warehouse

A **Warehouse** represents a physical location where inventory is stored. Each warehouse has:

- **Name:** Warehouse identifier (required)
- **Address:** Physical location (optional)
- **Code:** Unique warehouse code (optional, unique if provided)

Warehouses serve as the basis for organizing inventory across multiple locations.

**Example Warehouses:**

- Main Warehouse
- Site 1 Storage
- Equipment Depot
- Materials Yard

### Inventory Item

An **Inventory Item** represents a type of product or material in your inventory. Each item has:

- **SKU:** Stock Keeping Unit (unique identifier, required)
- **Name:** Item description (required)
- **Unit Cost:** Cost per unit (required)
- **Reorder Threshold:** Minimum quantity before low stock warning
- **Status:** `in_stock`, `low_stock`, or `out_of_stock` (auto-calculated)

**Lifecycle:**

```
in_stock → low_stock → out_of_stock (based on total quantity)
```

The status is automatically updated based on total quantity across all warehouses:

- `in_stock`: Total quantity > reorder threshold
- `low_stock`: Total quantity ≤ reorder threshold
- `out_of_stock`: Total quantity = 0

### Stock Level

A **Stock Level** represents the quantity of a specific item in a specific warehouse. It has:

- **Inventory Item:** Which item
- **Warehouse:** Which location
- **Quantity:** Current quantity on hand
- **Lock Version:** Optimistic locking to prevent race conditions

**Key Feature - Optimistic Locking:**
Uses `lock_version` to prevent concurrent update conflicts. The system automatically increments this on each update.

**Unique Constraint:**
Only one stock level record per (inventory_item, warehouse) pair.

### Stock Movement

A **Stock Movement** is a transaction record of inventory movement. It provides a complete audit trail with:

- **Inventory Item:** What item moved
- **Warehouse:** Which warehouse
- **Movement Type:** `inbound`, `outbound`, `adjustment`, `allocation`
- **Quantity:** Amount moved
- **Unit Cost:** Cost per unit (optional, for calculations)
- **Reference:** External reference number (PO, invoice, etc.)
- **Notes:** Additional context
- **Employee:** Who performed the movement (optional)
- **Project:** Associated project (optional)
- **Task:** Associated task (optional)
- **Applied At:** When the movement was applied (optional)

**Movement Types:**

- **Inbound:** Receiving inventory from suppliers/vendors
- **Outbound:** Issuing inventory for use or shipment
- **Adjustment:** Corrections due to inventory counts or corrections
- **Allocation:** Reserving inventory for a specific project

### Project Inventory

A **Project Inventory** links inventory items to projects with:

- **Inventory Item:** Which item
- **Project:** Which project
- **Quantity:** Quantity allocated
- **Purpose:** Why the inventory is allocated (optional)
- **Task:** Specific task if applicable (optional)

This allows tracking which inventory is reserved for specific projects and tasks.

---

## Data Models

### Warehouse Model

```ruby
class Warehouse < ApplicationRecord
  has_many :stock_movements, dependent: :restrict_with_error
  has_many :stock_levels, dependent: :delete_all
  has_many :inventory_items, through: :stock_levels

  validates :name, presence: true, length: { in: 2..100 }
  validates :code, uniqueness: true, allow_blank: true

  def total_stock_value
    stock_levels.joins(:inventory_item)
                .sum("stock_levels.quantity * inventory_items.unit_cost")
  end

  def recent_movements(limit = 10)
    stock_movements.includes(:inventory_item, :project, :employee)
                   .order(created_at: :desc)
                   .limit(limit)
  end
end
```

**Key Methods:**

- `total_stock_value` - Calculate total value of inventory in warehouse
- `recent_movements` - Get recent stock movements in this warehouse

---

### InventoryItem Model

```ruby
class InventoryItem < ApplicationRecord
  enum :status, { in_stock: 0, low_stock: 1, out_of_stock: 2 }

  has_many :stock_movements, dependent: :restrict_with_error
  has_many :stock_levels, dependent: :delete_all
  has_many :project_inventories, dependent: :delete_all
  has_many :projects, through: :project_inventories
  has_many :warehouses, through: :stock_levels

  validates :sku, presence: true, uniqueness: true, length: { in: 3..50 }
  validates :name, presence: true, length: { in: 3..150 }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }

  def total_quantity
    stock_levels.sum(:quantity)
  end

  def reserved_quantity
    project_inventories.sum(:quantity)
  end

  def available_quantity
    total_quantity - reserved_quantity
  end

  def refresh_status!
    qty = total_quantity
    new_status = if qty <= 0
                   :out_of_stock
                 elsif qty <= reorder_threshold
                   :low_stock
                 else
                   :in_stock
                 end
    update(status: new_status)
  end
end
```

**Key Methods:**

- `total_quantity` - Sum of quantities across all warehouses
- `reserved_quantity` - Sum of quantities allocated to projects
- `available_quantity` - Total - Reserved quantities
- `refresh_status!` - Recalculate status based on quantities

---

### StockLevel Model

```ruby
class StockLevel < ApplicationRecord
  belongs_to :inventory_item
  belongs_to :warehouse

  validates :inventory_item_id, :warehouse_id, presence: true
  validates :inventory_item_id, uniqueness: { scope: :warehouse_id }
end
```

**Key Feature:**
Uses optimistic locking via `lock_version` to handle concurrent updates safely.

---

### StockMovement Model

```ruby
class StockMovement < ApplicationRecord
  enum :movement_type, { inbound: 0, outbound: 1, adjustment: 2, allocation: 3 }

  belongs_to :inventory_item
  belongs_to :warehouse
  belongs_to :employee, optional: true
  belongs_to :project, optional: true
  belongs_to :task, optional: true

  validates :movement_type, :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }
end
```

---

### ProjectInventory Model

```ruby
class ProjectInventory < ApplicationRecord
  belongs_to :project
  belongs_to :inventory_item
  belongs_to :task, optional: true

  validates :project_id, :inventory_item_id, presence: true
  validates :project_id, uniqueness: { scope: :inventory_item_id }
end
```

**Unique Constraint:**
Only one allocation of a specific item per project.

---

## Features & Workflows

### Warehouse Management

**Creating a Warehouse:**

1. Navigate to `/inventory/warehouses/new`
2. Enter warehouse details:
   - **Name** (required) - Descriptive name
   - **Address** (optional) - Physical address
   - **Code** (optional) - Unique warehouse code
3. Save warehouse

**Viewing Warehouse Details:**

1. Go to `/inventory/warehouses/:id`
2. See:
   - Warehouse information
   - Recent stock movements
   - Total inventory value
3. Manage warehouse stock levels

**Warehouse Operations:**

- **Total Stock Value:** Automatically calculated sum of (quantity × unit_cost)
- **Recent Movements:** View last 10 movements in the warehouse
- **Stock Levels:** See all items and quantities in this warehouse

---

### Inventory Item Management

**Creating an Inventory Item:**

1. Navigate to `/inventory/inventory_items/new`
2. Enter item details:
   - **SKU** (required, unique) - Product code
   - **Name** (required) - Item description
   - **Unit Cost** (required) - Cost per unit
   - **Reorder Threshold** (default 10) - Low stock level
3. Save item (status automatically set to `in_stock`)

**Item Status Tracking:**

Status is automatically managed:

- **In Stock:** Total quantity > reorder threshold
- **Low Stock:** Total quantity ≤ reorder threshold (triggers alerts)
- **Out of Stock:** Total quantity = 0 (cannot allocate)

**Quantity Calculations:**

```
Total Quantity = Sum of all stock levels across warehouses
Reserved Quantity = Sum of all project allocations
Available Quantity = Total - Reserved
```

**Viewing Item Details:**

1. Go to `/inventory/inventory_items/:id`
2. See:
   - Item master data
   - Total quantity and status
   - Available quantity (total - reserved)
   - Stock levels per warehouse
   - Recent movements
   - Project allocations

---

### Stock Movement Workflow

**Recording an Inbound Movement (Receiving):**

1. Navigate to `/inventory/inventory_items/:id/stock_movements/new`
2. Select movement type: **Inbound**
3. Enter:
   - Warehouse (destination)
   - Quantity
   - Unit cost (optional, for cost tracking)
   - Reference (PO number, etc.)
   - Notes (supplier info, etc.)
   - Employee (who received it)
   - Applied date/time (optional)
4. Save movement
5. Stock level automatically increases in the warehouse

**Recording an Outbound Movement (Issue):**

1. Navigate to stock movement creation
2. Select movement type: **Outbound**
3. Enter:
   - Warehouse (source)
   - Quantity
   - Reference (invoice, work order, etc.)
   - Notes (reason for issue)
   - Employee (who issued it)
   - Project (if for a project)
   - Task (if for a specific task)
4. Save movement
5. Stock level automatically decreases

**Recording an Adjustment:**

1. Navigate to stock movement creation
2. Select movement type: **Adjustment**
3. Enter:
   - Warehouse
   - Quantity (positive for increase, handle as needed)
   - Reference (inventory count ID, etc.)
   - Notes (reason for adjustment)
   - Employee (who did the count/adjustment)
4. Save movement
5. Stock level is corrected

**Recording an Allocation:**

1. Navigate to stock movement creation
2. Select movement type: **Allocation**
3. Enter:
   - Warehouse (source)
   - Inventory item
   - Quantity
   - Project (which project this is for)
   - Task (which task, optional)
   - Notes (purpose)
4. Save movement
5. Creates both:
   - Stock movement record (audit trail)
   - Project inventory record (allocation tracking)

**Audit Trail Features:**

- Every movement is recorded with timestamp
- Employee who performed movement is tracked
- Related project/task is recorded
- All historical data is preserved for auditing
- Movement types clearly indicate transaction nature

---

### Project Inventory Allocation

**Allocating Inventory to a Project:**

1. From project show page, go to "Inventory" section
2. Click "Add Inventory"
3. Enter:
   - Inventory item (select from list)
   - Quantity to allocate
   - Purpose (what it's for)
   - Task (if for specific task)
4. Save allocation
5. Quantity is reserved and unavailable for other projects

**Viewing Project Allocations:**

1. Go to project show page
2. See all allocated inventory items
3. View total allocated quantity
4. Available quantity shows: (total - reserved)

**Modifying Allocations:**

1. Click edit on allocation
2. Adjust quantity
3. System validates available quantity
4. Save changes

**Deallocating Inventory:**

1. Click delete on allocation
2. Quantity is released back to available inventory
3. Can be allocated to another project

---

## User Roles & Permissions

### Role-Based Access Control

**Storekeeper Role:**

- Full access to inventory operations
- Create, read, update, delete inventory items
- Create and manage warehouses
- Record and view all stock movements
- Manage project allocations
- Generate inventory reports

**Site Manager Role:**

- View inventory information
- Request/reserve inventory for projects
- View allocation status
- Cannot create or modify master data

**Admin Role:**

- Same access as Storekeeper
- Can override or delete records if needed

**Other Roles:**

- View-only access to items relevant to their projects
- Cannot perform inventory operations

---

## Routes

These are server-side rendered routes (not JSON API endpoints). They return HTML responses with Hotwire/Turbo for fast, interactive updates.

### Warehouses

**List Warehouses:**

```
GET /inventory/warehouses
```

**Create Warehouse:**

```
POST /inventory/warehouses
Parameters: name, address, code
```

**Show Warehouse:**

```
GET /inventory/warehouses/:id
```

**Update Warehouse:**

```
PATCH /inventory/warehouses/:id
PUT /inventory/warehouses/:id
```

**Delete Warehouse:**

```
DELETE /inventory/warehouses/:id
```

---

### Inventory Items

**List Items:**

```
GET /inventory/inventory_items
```

**Create Item:**

```
POST /inventory/inventory_items
Parameters: sku, name, unit_cost, reorder_threshold, status
```

**Show Item:**

```
GET /inventory/inventory_items/:id
```

**Update Item:**

```
PATCH /inventory/inventory_items/:id
PUT /inventory/inventory_items/:id
```

**Delete Item:**

```
DELETE /inventory/inventory_items/:id
```

---

### Stock Movements

**List Movements:**

```
GET /inventory/inventory_items/:inventory_item_id/stock_movements
```

**Create Movement:**

```
POST /inventory/inventory_items/:inventory_item_id/stock_movements
Parameters: warehouse_id, movement_type, quantity, unit_cost, reference, notes, employee_id, project_id, task_id, applied_at
```

**Show Movement:**

```
GET /inventory/inventory_items/:inventory_item_id/stock_movements/:id
```

**Update Movement:**

```
PATCH /inventory/inventory_items/:inventory_item_id/stock_movements/:id
PUT /inventory/inventory_items/:inventory_item_id/stock_movements/:id
```

**Delete Movement:**

```
DELETE /inventory/inventory_items/:inventory_item_id/stock_movements/:id
```

---

### Project Inventories

**Create Allocation:**

```
POST /inventory/project_inventories
Parameters: project_id, inventory_item_id, quantity, purpose, task_id
```

**Update Allocation:**

```
PATCH /inventory/project_inventories/:id
PUT /inventory/project_inventories/:id
```

**Delete Allocation:**

```
DELETE /inventory/project_inventories/:id
```

---

## Best Practices

### Inventory Accuracy

1. **Regular Counts:** Perform physical inventory counts periodically
2. **Record Adjustments:** Use adjustment movements for discrepancies
3. **Reference Numbers:** Always include reference numbers for traceability
4. **Employee Tracking:** Record who performed each movement
5. **Timestamps:** Always apply accurate timestamps to movements

### Stock Management

1. **Monitor Reorder Levels:** Review low-stock alerts regularly
2. **Set Appropriate Thresholds:** Ensure reorder_threshold reflects lead times
3. **Prevent Overallocation:** Check available quantity before allocating
4. **Track by Project:** Link movements to projects for cost tracking
5. **Warehouse Balance:** Monitor quantities across warehouses for optimization

### Operational Efficiency

1. **Batch Movements:** Group similar movements for efficiency
2. **Warehouse Organization:** Use consistent naming and locations
3. **SKU Consistency:** Use unique, meaningful SKUs
4. **Cost Tracking:** Update unit costs regularly for accurate valuations
5. **Audit Trail:** Leverage movement history for audits and reconciliation

### Data Integrity

1. **Prevent Manual Edits:** Avoid editing stock levels directly; use movements
2. **Optimistic Locking:** System uses `lock_version` to prevent race conditions
3. **Validation:** Validate quantities and references before saving
4. **Historical Records:** Never delete movements; mark as corrections instead
5. **Reconciliation:** Periodically reconcile system quantities with physical counts

---

## Common Tasks

### Monthly Inventory Count

1. Schedule physical inventory count
2. Count all items in all warehouses
3. For each discrepancy:
   - Create adjustment movement
   - Enter counted quantity
   - Note reason for discrepancy
4. Update all stock levels
5. Generate reconciliation report

### Creating a New Item

1. Obtain item specifications (SKU, name, cost)
2. Go to `/inventory/inventory_items/new`
3. Fill in all required fields
4. Set appropriate reorder threshold
5. Create stock levels for initial quantities in warehouses
6. Use inbound movement to record initial quantities

### Allocating Inventory to Project

1. Verify item is in stock and available quantity is sufficient
2. Go to project show page
3. Click "Add Inventory"
4. Select item and desired quantity
5. Specify purpose and task if applicable
6. Record allocation
7. Verify reserved quantity in item details

### Generating Inventory Report

1. Go to `/inventory/inventory_items`
2. View list with statuses and quantities
3. Filter by status (in_stock, low_stock, out_of_stock)
4. Export or print for analysis
5. Use for procurement planning

### Warehouse Transfer

1. Create outbound movement from source warehouse
2. Create inbound movement to destination warehouse
3. Use same reference number for traceability
4. Link both movements as transfer pair in notes

---

## Troubleshooting

### Stock Level Not Updating

- Check that movement was saved successfully
- Verify warehouse and item references are correct
- Ensure quantity is positive for inbound, accounts for outbound
- Try refreshing the page

### Cannot Allocate Inventory to Project

- Check available quantity is sufficient
- Verify item status is not `out_of_stock`
- Ensure project allocation unique constraint isn't violated
- Try deallocating previous allocation first

### Discrepancy Between Physical and System Count

- Create adjustment movement with difference
- Document reason in movement notes
- Review recent movements for possible errors
- Check for unrecorded movements or data entry mistakes

### Low Stock Alert Not Appearing

- Verify reorder_threshold is set appropriately
- Check total_quantity calculation (sum across all warehouses)
- Refresh item status with `refresh_status!` if needed
- Review recent inbound movements that might have just arrived

---

## Related Documentation

- [Database Schema - Inventory Module](database_schema.md#inventory-module)
- [API Endpoints - Inventory](endpoints.md#inventory)
- [Architecture - Inventory Module](architecture.md#inventory-module)
