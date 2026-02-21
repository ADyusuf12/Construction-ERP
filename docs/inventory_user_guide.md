# Inventory Management User Guide

This guide helps you navigate and use the Inventory Management module in Earmark Systems. Whether you're a storekeeper managing stock, a site manager requesting materials, or a project manager tracking project inventory, you'll find step-by-step instructions for managing inventory items, stock movements, and project allocations.

## Table of Contents

- [Getting Started](#getting-started)
- [Inventory Items](#inventory-items)
- [Stock Movements](#stock-movements)
- [Project Inventory](#project-inventory)
- [Warehouses](#warehouses)
- [Storekeeper Functions](#storekeeper-functions)
- [Site Manager Functions](#site-manager-functions)
- [Project Manager Functions](#project-manager-functions)
- [Common Tasks](#common-tasks)
- [Troubleshooting](#troubleshooting)

---

## Getting Started

### Accessing Inventory Information

1. Log in to Earmark Systems
2. Click on the "Inventory" menu in the navigation bar
3. Select "Inventory Control" to view all inventory items

### Understanding Your Role

Your access level determines what you can do:

- **Storekeeper**: Full access to manage inventory items, stock movements, and warehouses
- **Site Manager**: Request and allocate inventory for projects
- **Project Manager**: View project inventory allocations
- **System Administrator**: All inventory functions plus system configuration

---

## Inventory Items

### Viewing Inventory Items

1. Go to **Inventory → Inventory Control**
2. See a list of all inventory items with:
   - SKU/Designation
   - Stock Level
   - Valuation (Unit Cost)
   - Status (In Stock/Low Stock/Out of Stock)

### Understanding Item Status

- **In Stock**: Green - Sufficient quantity available
- **Low Stock**: Yellow - Below reorder threshold
- **Out of Stock**: Red - No quantity available

### Searching for Items

- Use the search bar to find items by name or SKU
- Filter by status or other criteria
- Click on any item to view detailed information

### Item Details

Each item shows:

- **SKU/Designation**: Unique item identifier
- **Name**: Item description
- **Stock Level**: Current quantity available
- **Unit Cost**: Cost per unit
- **Status**: Current stock status
- **Reorder Threshold**: When to reorder
- **Unit**: Measurement unit (PCS, KG, etc.)

---

## Stock Movements

### What are Stock Movements?

Stock movements track all changes to inventory quantities, including receiving new items, issuing items to projects, and internal transfers between warehouses.

### Viewing Stock Movements

1. Go to **Inventory → Logistics Manifest**
2. See a list of all stock movements
3. Each movement shows:
   - Timestamp
   - Type (Inbound/Outbound/Adjustment/Site Delivery)
   - Item Name
   - Quantity
   - Project (if applicable)
   - Warehouse Node
   - Personnel

### Movement Types

- **Inbound**: Receiving items into warehouse
- **Outbound**: Issuing items from warehouse
- **Adjustment**: Correcting stock levels
- **Site Delivery**: Direct delivery to project site

### Movement Status

- **Pending**: Movement created but not applied
- **Applied**: Movement processed and stock updated
- **Cancelled**: Movement was cancelled and reversed

---

## Project Inventory

### What is Project Inventory?

Project inventory tracks materials allocated to specific projects, helping you monitor what's been reserved, issued, and what's still available.

### Viewing Project Allocations

1. Go to a project's detail page
2. Look for the "Inventory" section
3. See all allocated inventory items
4. View:
   - Allocated quantity
   - Issued quantity
   - Outstanding reservation

### Allocation Status

- **Reserved**: Quantity allocated but not yet issued
- **Issued**: Quantity delivered to project
- **Cancelled**: Allocation was cancelled and released

---

## Warehouses

### Viewing Warehouses

1. Go to **Inventory → Warehouses**
2. See a list of all warehouses
3. Each warehouse shows:
   - Name
   - Address
   - Code
   - Total Stock Value

### Warehouse Functions

- **Main Warehouse**: Central storage location
- **Site Warehouse**: Project-specific storage
- **Transit Warehouse**: Temporary storage during transfers

---

## Storekeeper Functions

### Creating New Inventory Items

1. Go to **Inventory → Inventory Control**
2. Click "Log New Asset" (green button)
3. Enter item details:
   - **SKU/Designation**: Unique item code
   - **Name**: Item description
   - **Description**: Additional details
   - **Unit Cost**: Cost per unit
   - **Unit**: Measurement unit
   - **Reorder Threshold**: When to reorder
   - **Default Location**: Where item is stored
   - **Status**: Active/Inactive
4. Click "Create Item"

### Recording Stock Movements

#### Inbound Movement (Receiving Items)

1. Go to the item's detail page
2. Click "Record Movement"
3. Select "Inbound" as movement type
4. Enter:
   - **Quantity**: Number of items received
   - **Unit Cost**: Cost per unit
   - **Reference**: Supplier invoice or PO number
   - **Notes**: Any additional information
   - **Destination Warehouse**: Where items are stored
5. Click "Create Movement"

#### Outbound Movement (Issuing Items)

1. Go to the item's detail page
2. Click "Record Movement"
3. Select "Outbound" as movement type
4. Enter:
   - **Quantity**: Number of items to issue
   - **Reference**: Project or task reference
   - **Notes**: Purpose of issue
   - **Source Warehouse**: Where items are coming from
   - **Project**: Which project the items are for
   - **Task**: Which task the items are for
5. Click "Create Movement"

#### Site Delivery Movement

1. Go to the item's detail page
2. Click "Record Movement"
3. Select "Site Delivery" as movement type
4. Enter:
   - **Quantity**: Number of items to deliver
   - **Reference**: Delivery reference
   - **Notes**: Delivery details
   - **Project**: Which project the items are for
   - **Task**: Which task the items are for
5. Click "Create Movement"

#### Adjustment Movement (Correcting Stock)

1. Go to the item's detail page
2. Click "Record Movement"
3. Select "Adjustment" as movement type
4. Enter:
   - **Quantity**: New correct quantity
   - **Reference**: Reason for adjustment
   - **Notes**: Details of discrepancy
   - **Warehouse**: Which warehouse is being adjusted
5. Click "Create Movement"

### Managing Warehouses

1. Go to **Inventory → Warehouses**
2. Click "Add Warehouse" (if you have permission)
3. Enter:
   - **Name**: Warehouse name
   - **Address**: Physical location
   - **Code**: Short code for reference
4. Click "Create Warehouse"

### Cancelling Stock Movements

1. Go to the movement's detail page
2. Click "Cancel Movement"
3. Enter reason for cancellation
4. Confirm cancellation
5. System automatically reverses the stock changes

---

## Site Manager Functions

### Requesting Inventory for Projects

1. Go to your project's detail page
2. Click "Add Inventory" in the inventory section
3. Select the item you need
4. Enter:
   - **Quantity**: How many you need
   - **Purpose**: What you'll use it for
   - **Task**: Which task it's for (if applicable)
   - **Warehouse**: Where to take it from (optional)
5. Click "Create Allocation"

### Viewing Project Inventory Status

1. Go to your project's detail page
2. Look at the inventory section
3. See:
   - What items are allocated
   - How much is reserved vs issued
   - What's still available

### Managing Project Allocations

1. View your project's allocations
2. See what's been issued vs reserved
3. Track usage against allocations
4. Request additional items as needed

---

## Project Manager Functions

### Viewing Project Inventory

1. Go to your project's detail page
2. Look at the inventory section
3. See all materials allocated to your project
4. View:
   - Total allocated quantity
   - Quantity already issued
   - Outstanding reservations

### Monitoring Project Materials

1. Track what materials have been issued
2. Monitor remaining allocations
3. Plan for additional material needs
4. Ensure materials are available when needed

---

## Common Tasks

### Monthly Inventory Count (Storekeeper)

**Step 1: Physical Count**

- Count all items in all warehouses
- Record actual quantities

**Step 2: Identify Discrepancies**

- Compare physical count with system count
- Note any differences

**Step 3: Create Adjustments**

- For each discrepancy, create an adjustment movement
- Enter the correct counted quantity
- Note the reason for the difference

**Step 4: Update System**

- Apply all adjustment movements
- Verify stock levels are correct

**Step 5: Generate Report**

- Create reconciliation report
- Document any significant discrepancies

### Creating a New Item (Storekeeper)

**Step 1: Gather Information**

- Obtain item specifications (SKU, name, cost)
- Determine reorder threshold
- Identify default storage location

**Step 2: Create Item Record**

- Go to Inventory Control
- Click "Log New Asset"
- Enter all required information
- Set appropriate reorder threshold

**Step 3: Set Initial Stock**

- Create stock levels for initial quantities
- Use inbound movement to record initial quantities

### Allocating Inventory to Project (Site Manager)

**Step 1: Verify Availability**

- Check item is in stock
- Verify sufficient quantity available
- Check warehouse has item if specified

**Step 2: Create Allocation**

- Go to project detail page
- Click "Add Inventory"
- Select item and desired quantity
- Specify purpose and task if applicable
- Record allocation

**Step 3: Track Usage**

- Monitor issued vs reserved quantities
- Request additional items as needed
- Update allocations if requirements change

### Issuing Materials to Project (Storekeeper)

**Step 1: Verify Request**

- Check project allocation exists
- Verify sufficient reserved quantity
- Confirm project needs the materials

**Step 2: Create Outbound Movement**

- Go to item detail page
- Record outbound movement
- Link to project and task
- Enter quantity to issue

**Step 3: Update Allocation**

- System automatically updates project allocation
- Issued quantity increases
- Reserved quantity decreases

### Cancelling an Incorrect Movement (Storekeeper)

**Step 1: Identify Error**

- Find the incorrect movement
- Determine what needs to be corrected

**Step 2: Cancel Movement**

- Go to movement detail page
- Click "Cancel Movement"
- Enter reason for cancellation

**Step 3: Verify Reversal**

- Check stock levels are restored
- Verify project allocations are updated
- Create new correct movement if needed

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
- Verify item status is not "out of stock"
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

### Cannot Find Item

- Check spelling in search
- Try partial name or SKU search
- Verify item is active (not inactive)
- Check if item exists in correct warehouse
- Contact storekeeper if item is missing

### Insufficient Stock for Allocation

- Check available quantity across all warehouses
- Verify no other allocations are using the stock
- Check for pending movements that might affect quantity
- Consider creating a purchase request
- Contact storekeeper for stock availability

### Movement Applied at Wrong Time

- Check if applied_at timestamp is correct
- Verify movement was applied when it should have been
- Check for system clock issues
- Contact system administrator if timestamps are wrong

---

## Tips and Best Practices

### For Storekeepers

- Always verify quantities before recording movements
- Use reference numbers for traceability
- Record who performed each movement
- Apply accurate timestamps to movements
- Document cancellations with clear reasons
- Regular physical inventory counts

### For Site Managers

- Plan material needs in advance
- Request materials with sufficient lead time
- Track project allocations regularly
- Communicate with storekeeper about urgent needs
- Return unused materials when possible

### For Project Managers

- Monitor project inventory regularly
- Plan for material requirements
- Track issued vs reserved quantities
- Ensure materials are available when needed
- Coordinate with site managers on material needs

---

## Related Documentation

- [Database Schema - Inventory Module](database_schema.md#inventory-module)
- [API Endpoints - Inventory](endpoints.md#inventory)
- [Architecture - Inventory Module](architecture.md#inventory-module)
