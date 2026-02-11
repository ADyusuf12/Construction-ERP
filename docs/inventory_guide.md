4. Save movement
5. MovementApplier automatically:
   - Decreases project inventory reservation
   - Creates project expense record
   - Updates item status
6. Note: Site delivery does NOT reduce warehouse stock - it's a direct delivery

**Audit Trail Features:**

- Every movement is recorded with timestamp
- Employee who performed movement is tracked
- Related project/task is recorded
- All historical data is preserved for auditing
- Movement types clearly indicate transaction nature

**Reversing/Cancelling a Movement:**

1. Go to the movement detail page
2. Click "Reverse" or "Cancel"
3. Enter reason for cancellation
4. MovementCanceller automatically:
   - Reverses the stock level changes
   - Restores project inventory reservations
   - Deletes linked project expense
   - Sets cancelled_at and cancellation_reason

---

### Project Inventory Allocation

**Allocating Inventory to a Project:**

1. From project show page, go to "Inventory" section
2. Click "Add Inventory"
3. Enter:
   - Inventory item (select from list)
   - Quantity to allocate
   - Warehouse (optional - for stock validation)
   - Purpose (what it's for)
   - Task (if for specific task)
4. Save allocation
5. Quantity is reserved and unavailable for other projects
6. System validates warehouse has sufficient stock

**Viewing Project Allocations:**

1. Go to project show page
2. See all allocated inventory items
3. View total allocated quantity
4. View issued quantity (already delivered)
5. Outstanding reservation shows: reserved - issued

**Modifying Allocations:**

1. Click edit on allocation
2. Adjust quantity
3. System validates available quantity
4. Save changes

**Cancelling Allocations:**

1. Click cancel on allocation
2. Enter reason
3. System sets cancelled_at and cancellation_reason
4. quantity_reserved set to 0
5. Quantity is released back to available inventory

---

### Movement Cancellation Workflow

**When to Cancel a Movement:**

- Incorrect quantity was entered
- Wrong item was selected
- Movement was recorded in error
- Supplier returned received goods

**Cancellation Process:**

1. Navigate to the movement detail
2. Click "Cancel Movement"
3. Provide cancellation reason
4. Confirm cancellation

**What Happens on Cancellation:**

For **Inbound**:
- Decreases stock level at destination warehouse
- Item status is refreshed

For **Outbound**:
- Increases stock level at source warehouse
- Restores project inventory reservation
- Deletes linked project expense

For **Site Delivery**:
- Restores project inventory reservation
- Deletes linked project expense

For **Adjustment**:
- Sets stock level quantity to 0
- Note: Original stock level value is lost

---

## User Roles & Permissions

### Role-Based Access Control

**Storekeeper Role:**

- Full access to inventory operations
- Create, read, update, delete inventory items
- Create and manage warehouses
- Record and view all stock movements
- Manage project allocations
- Cancel movements with reason
- Generate inventory reports

**Site Manager Role:**

- View inventory information
- Request/reserve inventory for projects
- View allocation status
- Cannot create or modify master data
- Cannot cancel movements

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
Parameters: sku, name, description, unit_cost, unit, reorder_threshold, default_location, status
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

**List Movements (for an item):**

```
GET /inventory/inventory_items/:inventory_item_id/stock_movements
```

**List All Movements:**

```
GET /inventory/stock_movements
```

**Create Movement:**

```
POST /inventory/inventory_items/:inventory_item_id/stock_movements
Parameters: movement_type, quantity, unit_cost, reference, notes, employee_id,
           source_warehouse_id, destination_warehouse_id, project_id, task_id, applied_at
```

**Show Movement:**

```
GET /inventory/inventory_items/:inventory_item_id/stock_movements/:id
```

**Reverse/Cancel Movement:**

```
POST /inventory/inventory_items/:inventory_item_id/stock_movements/:id/reverse
```

---

### Project Inventories

**Create Allocation:**

```
POST /inventory/project_inventories
Parameters: project_id, inventory_item_id, quantity_reserved, purpose, task_id, warehouse_id
```

**Edit Allocation:**

```
GET /inventory/project_inventories/:id/edit
```

**Update Allocation:**

```
PATCH /inventory/project_inventories/:id
PUT /inventory/project_inventories/:id
```

**Delete/Cancel Allocation:**

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
6. **Document Cancellations:** Always provide cancellation reasons

### Stock Management

1. **Monitor Reorder Levels:** Review low-stock alerts regularly
2. **Set Appropriate Thresholds:** Ensure reorder_threshold reflects lead times
3. **Prevent Overallocation:** Check available quantity before allocating
4. **Track by Project:** Link movements to projects for cost tracking
5. **Warehouse Balance:** Monitor quantities across warehouses for optimization
6. **Site Delivery vs Outbound:** Use site_delivery for direct site deliveries, outbound for regular issues

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
4. **Historical Records:** Never delete movements; cancel and reverse instead
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
5. Specify warehouse (optional), purpose and task if applicable
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

### Cancelling an Incorrect Movement

1. Identify the incorrect movement
2. Navigate to movement detail
3. Click "Cancel" or "Reverse"
4. Enter reason: "Incorrect quantity entered"
5. Verify stock levels are restored
6. Create new correct movement if needed

---

## Troubleshooting

### Stock Level Not Updating

- Check that movement was saved successfully
- Verify warehouse references are correct
- Ensure quantity is positive for inbound, accounts for outbound
- Check if movement was cancelled
- Try refreshing the page
- Verify MovementApplier ran without errors

### Cannot Allocate Inventory to Project

- Check available quantity is sufficient
- Verify item status is not `out_of_stock`
- If warehouse specified, ensure warehouse has item in stock
- Ensure project allocation unique constraint isn't violated
- Try deallocating previous allocation first

### Discrepancy Between Physical and System Count

- Create adjustment movement with difference
- Document reason in movement notes
- Review recent movements for possible errors
- Check for cancelled movements that weren't reversed properly
- Verify no concurrent updates caused race conditions

### Low Stock Alert Not Appearing

- Verify reorder_threshold is set appropriately
- Check total_quantity calculation (sum across all warehouses)
- Refresh item status with `refresh_status!` if needed
- Review recent inbound movements that might have just arrived
- Check if item has been manually marked with incorrect status

### Movement Cancellation Failed

- Check if movement is already cancelled
- Verify MovementCanceller has proper permissions
- Ensure no dependent records block cancellation
- Check cancellation reason is provided
- Verify warehouse still exists

### Warehouse Deletion Blocked

- Check dependent stock movements exist
- Review stock levels at this warehouse
- Check project inventories linked to warehouse
- Move inventory or cancel movements first
- Use force delete if appropriate

---

## Service Objects

### InventoryManager::MovementApplier

Handles applying stock movements to update stock levels and create expenses.

```ruby
module InventoryManager
  class MovementApplier
    def initialize(stock_movement)
      @movement = stock_movement
    end

    def call
      # Runs in transaction
      case @movement.movement_type
      when "inbound"      then apply_inbound
      when "outbound"     then apply_outbound
      when "adjustment"   then apply_adjustment
      when "site_delivery" then apply_site_delivery
      end

      @movement.inventory_item.refresh_status!
      @movement.update!(applied_at: Time.current)
    end
  end
end
```

**Behavior by Movement Type:**

- **Inbound:** Creates/updates stock level, increments quantity
- **Outbound:** Decreases stock level, updates project inventory, creates expense
- **Adjustment:** Sets stock level to specified quantity
- **Site Delivery:** Updates project inventory, creates expense (no stock change)

### InventoryManager::MovementCanceller

Handles reversing stock movements and restoring stock levels.

```ruby
module InventoryManager
  class MovementCanceller
    def initialize(stock_movement)
      @movement = stock_movement
    end

    def call
      case @movement.movement_type
      when "inbound"        then cancel_inbound
      when "outbound"       then cancel_outbound
      when "site_delivery"  then cancel_site_delivery
      when "adjustment"     then cancel_adjustment
      end

      @movement.project_expense&.destroy
    end
  end
end
```

**Behavior by Movement Type:**

- **Inbound:** Decreases stock level at destination warehouse
- **Outbound:** Increases stock level, restores project reservation, deletes expense
- **Site Delivery:** Restores project reservation, deletes expense
- **Adjustment:** Sets stock level to 0

---

## Related Documentation

- [Database Schema - Inventory Module](database_schema.md#inventory-module)
- [API Endpoints - Inventory](endpoints.md#inventory)
- [Architecture - Inventory Module](architecture.md#inventory-module)
