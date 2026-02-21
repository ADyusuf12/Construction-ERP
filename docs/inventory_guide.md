# Inventory Module Guide

This guide provides comprehensive documentation for the Inventory module, which handles items, warehouses, stock levels, and movements for the Earmark Systems application.

## Table of Contents

- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Data Models](#data-models)
- [Features & Workflows](#features--workflows)
- [User Roles & Permissions](#user-roles--permissions)
- [Routes](#routes)
- [Best Practices](#best-practices)

---

## Overview

The Inventory module is responsible for managing all aspects of the organization's inventory, including:

- **Inventory Items Master:** A master list of all products and materials.
- **Warehouse Management:** Tracking inventory across multiple physical or virtual locations.
- **Stock Level Tracking:** Real-time visibility into item quantities.
- **Stock Movements:** A detailed audit trail of all inventory transactions.
- **Project Inventory Allocation:** Reserving and assigning inventory to specific projects.

### Core Responsibilities

1.  **Item Master:** Maintain a central, authoritative source for all inventory items.
2.  **Warehouse Logistics:** Manage storage locations and the quantities within them.
3.  **Stock Auditing:** Provide a complete history of every stock movement for traceability.
4.  **Project Costing:** Link inventory usage to projects to track material costs.

---

## Key Concepts

### Inventory Item

An **Inventory Item** is a unique product or material tracked by the system. Each item has:

- **SKU (Stock Keeping Unit):** A unique identifier for the item.
- **Name & Description:** Human-readable details about the item.
- **Unit Cost:** The cost of a single unit of the item.
- **Reorder Threshold:** The stock level at which a new order should be placed.
- **Status:** Automatically calculated based on stock levels (`in_stock`, `low_stock`, `out_of_stock`).

### Warehouse

A **Warehouse** represents a physical or logical location where inventory is stored. It has a `name`, `code`, and `address`.

### Stock Level

A **Stock Level** represents the quantity of a specific `Inventory Item` at a specific `Warehouse`. It is the "quantity on hand" at that location.

### Stock Movement

A **Stock Movement** is a record of any change in inventory. This is the core of the audit trail. The main types are:

- **Inbound:** Receiving new stock from a supplier (increases stock level).
- **Outbound:** Issuing stock from a warehouse for a project (decreases stock level).
- **Adjustment:** Correcting a discrepancy after a physical count (sets stock level).
- **Site Delivery:** Delivering stock directly to a project site without it ever entering a warehouse.

### Project Inventory

A **Project Inventory** record represents an allocation or reservation of a specific quantity of an `Inventory Item` for a `Project`. This ensures materials are set aside and not used for other projects.

---

## Data Models

*(This section would typically contain the Ruby model definitions for `InventoryItem`, `Warehouse`, `StockLevel`, `StockMovement`, and `ProjectInventory`. For brevity, they are omitted here but are present in the source code.)*

---

## Features & Workflows

### Stock Movement Workflow

**Recording a Movement (e.g., Inbound):**

1.  Navigate to the `Inventory Item`'s detail page.
2.  Click "New Movement".
3.  Select the `movement_type` (e.g., "Inbound").
4.  Enter the `quantity`, `unit_cost`, and `destination_warehouse`.
5.  Save the movement. The `MovementApplier` service automatically updates the `StockLevel` for that item and warehouse.

**Reversing a Movement:**

1.  From a movement's detail page, click "Reverse".
2.  Provide a reason for the reversal.
3.  The `MovementCanceller` service automatically reverses the stock changes. For an "Outbound" movement, it would increase the stock level at the source warehouse and restore the project inventory reservation.

### Project Inventory Allocation

**Allocating Inventory to a Project:**

1.  From a project's detail page, navigate to the "Inventory" section.
2.  Click "Add Inventory".
3.  Select an `Inventory Item` and the `quantity_reserved`.
4.  The system validates that sufficient stock is available.
5.  The quantity is now reserved and cannot be allocated to other projects.

---

## User Roles & Permissions

**Storekeeper Role:**
- Full access to all inventory operations.
- Can create/manage items, warehouses, and movements.

**Site Manager Role:**
- Can view inventory information and request/reserve items for projects.
- Cannot create master data or cancel movements.

**Admin Role:**
- Has the same permissions as a Storekeeper.

---

## Routes

These are server-side rendered routes that return HTML.

### Warehouses

-   `GET /inventory/warehouses` - List all warehouses.
-   `POST /inventory/warehouses` - Create a new warehouse.
-   `GET /inventory/warehouses/:id` - Show a specific warehouse.
-   `PATCH/PUT /inventory/warehouses/:id` - Update a warehouse.
-   `DELETE /inventory/warehouses/:id` - Delete a warehouse.

### Inventory Items

-   `GET /inventory/inventory_items` - List all items.
-   `POST /inventory/inventory_items` - Create a new item.
-   `GET /inventory/inventory_items/:id` - Show a specific item.
-   `PATCH/PUT /inventory/inventory_items/:id` - Update an item.
-   `DELETE /inventory/inventory_items/:id` - Delete an item.

### Stock Movements

-   `GET /inventory/stock_movements` - List all movements across all items.
-   `GET /inventory/inventory_items/:inventory_item_id/stock_movements` - List movements for a specific item.
-   `POST /inventory/inventory_items/:inventory_item_id/stock_movements` - Create a new movement for an item.
-   `GET /inventory/stock_movements/:id` - Show a specific movement.
-   `POST /inventory/inventory_items/:inventory_item_id/stock_movements/:id/reverse` - Reverse a movement for a specific item.
-   `POST /inventory/stock_movements/:id/reverse` - Reverse a specific movement.

### Project Inventories (Allocations)

-   `GET /inventory/project_inventories/new` - Show form to create a new allocation.
-   `POST /inventory/project_inventories` - Create a new allocation.
-   `GET /inventory/project_inventories/:id` - Show a specific allocation.
-   `GET /inventory/project_inventories/:id/edit` - Show form to edit an allocation.
-   `PATCH/PUT /inventory/project_inventories/:id` - Update an allocation.
-   `DELETE /inventory/project_inventories/:id` - Delete/cancel an allocation.

---

## Best Practices

-   **Use Movements for All Changes:** Never edit stock levels directly. Use `Inbound`, `Outbound`, or `Adjustment` movements to ensure a complete audit trail.
-   **Regular Physical Counts:** Perform regular physical inventory counts and use `Adjustment` movements to reconcile any discrepancies.
-   **Traceability:** Use reference numbers and link movements to employees and projects for full traceability.

---

## Service Objects

### InventoryManager::MovementApplier

This service is responsible for applying the effects of a stock movement, such as updating stock levels and creating project expenses.

### InventoryManager::MovementCanceller

This service is responsible for reversing the effects of a stock movement, restoring stock levels and project reservations.

---

## Related Documentation

- [Database Schema - Inventory Module](database_schema.md#inventory-module)
- [Architecture - Inventory Module](architecture.md#inventory-module)
