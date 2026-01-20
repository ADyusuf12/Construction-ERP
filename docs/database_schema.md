# Database Schema Overview

This document provides a comprehensive overview of the database schema for the Hamzis Systems application. The schema is defined in `db/schema.rb`.

## Table of Contents

- [Core Tables](#core-tables)
- [Project Management Tables](#project-management-tables)
- [HR Module Tables](#hr-module-tables)
- [Accounting Module Tables](#accounting-module-tables)
- [Inventory Module Tables](#inventory-module-tables)
- [Background Jobs Tables](#background-jobs-tables)
- [Foreign Keys](#foreign-keys)

---

## Core Tables

### `users`

Stores user account information, including credentials and roles.

| Column                   | Type       | Null | Default | Indexes                                        |
| ------------------------ | ---------- | ---- | ------- | ---------------------------------------------- |
| `id`                     | `bigint`   | no   |         | Primary Key                                    |
| `email`                  | `string`   | no   | `""`    | `index_users_on_email` (unique)                |
| `encrypted_password`     | `string`   | no   | `""`    |                                                |
| `reset_password_token`   | `string`   | yes  |         | `index_users_on_reset_password_token` (unique) |
| `reset_password_sent_at` | `datetime` | yes  |         |                                                |
| `remember_created_at`    | `datetime` | yes  |         |                                                |
| `role`                   | `integer`  | yes  |         |                                                |
| `created_at`             | `datetime` | no   |         |                                                |
| `updated_at`             | `datetime` | no   |         |                                                |

**Associations:**

- `has_many :projects`
- `has_many :assignments`
- `has_many :tasks, through: :assignments`
- `has_one :hr_employee`
- `has_many :reports`

---

### `projects`

Stores information about projects.

| Column        | Type            | Null | Default | Indexes                     |
| ------------- | --------------- | ---- | ------- | --------------------------- |
| `id`          | `bigint`        | no   |         | Primary Key                 |
| `name`        | `string`        | yes  |         |                             |
| `description` | `text`          | yes  |         |                             |
| `status`      | `integer`       | no   | `0`     |                             |
| `deadline`    | `datetime`      | yes  |         |                             |
| `budget`      | `decimal(12,2)` | yes  |         |                             |
| `progress`    | `integer`       | no   | `0`     |                             |
| `user_id`     | `bigint`        | no   |         | `index_projects_on_user_id` |
| `created_at`  | `datetime`      | no   |         |                             |
| `updated_at`  | `datetime`      | no   |         |                             |

**Associations:**

- `belongs_to :user`
- `has_many :tasks`
- `has_many :transactions`
- `has_many :reports`

---

### `tasks`

Stores information about tasks, which belong to projects.

| Column       | Type       | Null | Default | Indexes                     |
| ------------ | ---------- | ---- | ------- | --------------------------- |
| `id`         | `bigint`   | no   |         | Primary Key                 |
| `title`      | `string`   | no   |         |                             |
| `details`    | `text`     | yes  |         |                             |
| `status`     | `integer`  | no   | `0`     |                             |
| `due_date`   | `datetime` | yes  |         |                             |
| `weight`     | `integer`  | no   | `1`     |                             |
| `project_id` | `bigint`   | no   |         | `index_tasks_on_project_id` |
| `created_at` | `datetime` | no   |         |                             |
| `updated_at` | `datetime` | no   |         |                             |

**Associations:**

- `belongs_to :project`
- `has_many :assignments`
- `has_many :users, through: :assignments`

---

### `assignments`

A join table that assigns users to tasks.

| Column       | Type       | Null | Default | Indexes                        |
| ------------ | ---------- | ---- | ------- | ------------------------------ |
| `id`         | `bigint`   | no   |         | Primary Key                    |
| `task_id`    | `bigint`   | no   |         | `index_assignments_on_task_id` |
| `user_id`    | `bigint`   | no   |         | `index_assignments_on_user_id` |
| `created_at` | `datetime` | no   |         |                                |
| `updated_at` | `datetime` | no   |         |                                |

**Associations:**

- `belongs_to :task`
- `belongs_to :user`

---

### `transactions`

Stores financial transactions related to projects.

| Column             | Type            | Null | Default | Indexes                                     |
| ------------------ | --------------- | ---- | ------- | ------------------------------------------- |
| `id`               | `bigint`        | no   |         | Primary Key                                 |
| `date`             | `date`          | no   |         | `index_transactions_on_project_id_and_date` |
| `description`      | `string`        | no   |         |                                             |
| `amount`           | `decimal(12,2)` | no   |         |                                             |
| `transaction_type` | `integer`       | no   | `0`     | `index_transactions_on_transaction_type`    |
| `status`           | `integer`       | no   | `0`     | `index_transactions_on_status`              |
| `reference`        | `string`        | yes  |         |                                             |
| `notes`            | `text`          | yes  |         |                                             |
| `project_id`       | `bigint`        | no   |         | `index_transactions_on_project_id`          |
| `created_at`       | `datetime`      | no   |         |                                             |
| `updated_at`       | `datetime`      | no   |         |                                             |

**Associations:**

- `belongs_to :project`

---

### `hr_employees`

Stores information about employees for the HR module.

| Column              | Type           | Null | Default | Indexes                                    |
| ------------------- | -------------- | ---- | ------- | ------------------------------------------ |
| `id`                | `bigint`       | no   |         | Primary Key                                |
| `hamzis_id`         | `string`       | no   |         | `index_hr_employees_on_hamzis_id` (unique) |
| `department`        | `string`       | yes  |         |                                            |
| `position_title`    | `string`       | yes  |         |                                            |
| `hire_date`         | `date`         | yes  |         |                                            |
| `status`            | `integer`      | yes  | `0`     |                                            |
| `leave_balance`     | `integer`      | yes  | `0`     |                                            |
| `performance_score` | `decimal(5,2)` | yes  |         |                                            |
| `user_id`           | `bigint`       | yes  |         | `index_hr_employees_on_user_id`            |
| `manager_id`        | `bigint`       | yes  |         | `index_hr_employees_on_manager_id`         |
| `created_at`        | `datetime`     | no   |         |                                            |
| `updated_at`        | `datetime`     | no   |         |                                            |

**Associations:**

- `belongs_to :user` (optional)
- `belongs_to :manager, class_name: 'HrEmployee', optional: true`
- `has_many :subordinates, class_name: 'HrEmployee', foreign_key: 'manager_id'`
- `has_many :leaves, class_name: 'HrLeave', foreign_key: 'employee_id'`
- `has_one :personal_detail, class_name: 'HrPersonalDetail'`
- `has_many :salaries, class_name: 'Accounting::Salary'`

---

### `hr_leaves`

Stores leave requests for employees.

| Column        | Type       | Null | Default | Indexes                          |
| ------------- | ---------- | ---- | ------- | -------------------------------- |
| `id`          | `bigint`   | no   |         | Primary Key                      |
| `employee_id` | `bigint`   | no   |         | `index_hr_leaves_on_employee_id` |
| `manager_id`  | `bigint`   | yes  |         | `index_hr_leaves_on_manager_id`  |
| `start_date`  | `date`     | no   |         |                                  |
| `end_date`    | `date`     | no   |         |                                  |
| `reason`      | `text`     | no   |         |                                  |
| `status`      | `integer`  | no   | `0`     |                                  |
| `created_at`  | `datetime` | no   |         |                                  |
| `updated_at`  | `datetime` | no   |         |                                  |

**Associations:**

- `belongs_to :employee, class_name: 'HrEmployee'`
- `belongs_to :manager, class_name: 'HrEmployee', optional: true`

---

### `hr_personal_details`

Stores personal details for employees.

| Column                    | Type       | Null | Default | Indexes                                    |
| ------------------------- | ---------- | ---- | ------- | ------------------------------------------ |
| `id`                      | `bigint`   | no   |         | Primary Key                                |
| `employee_id`             | `bigint`   | yes  |         | `index_hr_personal_details_on_employee_id` |
| `first_name`              | `string`   | yes  |         |                                            |
| `last_name`               | `string`   | yes  |         |                                            |
| `dob`                     | `date`     | yes  |         |                                            |
| `gender`                  | `integer`  | yes  |         |                                            |
| `bank_name`               | `string`   | yes  |         |                                            |
| `account_number`          | `string`   | yes  |         |                                            |
| `account_name`            | `string`   | yes  |         |                                            |
| `means_of_identification` | `integer`  | yes  |         |                                            |
| `id_number`               | `string`   | yes  |         |                                            |
| `marital_status`          | `integer`  | yes  |         |                                            |
| `address`                 | `text`     | yes  |         |                                            |
| `phone_number`            | `string`   | yes  |         |                                            |
| `created_at`              | `datetime` | no   |         |                                            |
| `updated_at`              | `datetime` | no   |         |                                            |

**Associations:**

- `belongs_to :employee, class_name: 'HrEmployee'`

---

### `reports`

Stores project reports.

| Column             | Type       | Null | Default | Indexes                       |
| ------------------ | ---------- | ---- | ------- | ----------------------------- |
| `id`               | `bigint`   | no   |         | Primary Key                   |
| `project_id`       | `bigint`   | no   |         | `index_reports_on_project_id` |
| `user_id`          | `bigint`   | no   |         | `index_reports_on_user_id`    |
| `report_date`      | `date`     | no   |         |                               |
| `report_type`      | `integer`  | no   | `0`     |                               |
| `status`           | `integer`  | no   | `0`     |                               |
| `progress_summary` | `text`     | yes  |         |                               |
| `issues`           | `text`     | yes  |         |                               |
| `next_steps`       | `text`     | yes  |         |                               |
| `created_at`       | `datetime` | no   |         |                               |
| `updated_at`       | `datetime` | no   |         |                               |

**Associations:**

- `belongs_to :project`
- `belongs_to :user`

---

## Accounting Module

### `accounting_salary_batches`

Represents a batch of salaries to be processed.

| Column         | Type       | Null | Default | Indexes     |
| -------------- | ---------- | ---- | ------- | ----------- |
| `id`           | `bigint`   | no   |         | Primary Key |
| `name`         | `string`   | yes  |         |             |
| `period_start` | `date`     | yes  |         |             |
| `period_end`   | `date`     | yes  |         |             |
| `status`       | `integer`  | yes  |         |             |
| `created_at`   | `datetime` | no   |         |             |
| `updated_at`   | `datetime` | no   |         |             |

**Associations:**

- `has_many :salaries, class_name: 'Accounting::Salary'`

### `accounting_salaries`

Represents an employee's salary for a specific batch.

| Column             | Type            | Null | Default | Indexes                                    |
| ------------------ | --------------- | ---- | ------- | ------------------------------------------ |
| `id`               | `bigint`        | no   |         | Primary Key                                |
| `employee_id`      | `bigint`        | no   |         | `index_accounting_salaries_on_employee_id` |
| `batch_id`         | `bigint`        | no   |         | `index_accounting_salaries_on_batch_id`    |
| `base_pay`         | `decimal(12,2)` | no   |         |                                            |
| `allowances`       | `decimal(12,2)` | yes  | `0.0`   |                                            |
| `deductions_total` | `decimal(12,2)` | yes  | `0.0`   |                                            |
| `net_pay`          | `decimal(12,2)` | no   |         |                                            |
| `status`           | `integer`       | no   | `0`     |                                            |
| `created_at`       | `datetime`      | no   |         |                                            |
| `updated_at`       | `datetime`      | no   |         |                                            |

**Associations:**

- `belongs_to :employee, class_name: 'HrEmployee'`
- `belongs_to :batch, class_name: 'Accounting::SalaryBatch'`
- `has_many :deductions, class_name: 'Accounting::Deduction'`

### `accounting_deductions`

Represents deductions from an employee's salary.

| Column           | Type            | Null | Default | Indexes                                    |
| ---------------- | --------------- | ---- | ------- | ------------------------------------------ |
| `id`             | `bigint`        | no   |         | Primary Key                                |
| `salary_id`      | `bigint`        | no   |         | `index_accounting_deductions_on_salary_id` |
| `deduction_type` | `integer`       | no   |         |                                            |
| `amount`         | `decimal(12,2)` | no   |         |                                            |
| `notes`          | `text`          | yes  |         |                                            |
| `created_at`     | `datetime`      | no   |         |                                            |
| `updated_at`     | `datetime`      | no   |         |                                            |

**Associations:**

- `belongs_to :salary, class_name: 'Accounting::Salary'`

---

## Inventory Module

### `warehouses`

Stores information about physical warehouse locations where inventory is stored.

| Column       | Type       | Null | Default | Indexes                             |
| ------------ | ---------- | ---- | ------- | ----------------------------------- |
| `id`         | `bigint`   | no   |         | Primary Key                         |
| `name`       | `string`   | no   |         | `index_warehouses_on_name`          |
| `address`    | `text`     | yes  |         |                                     |
| `code`       | `string`   | yes  |         | `index_warehouses_on_code` (unique) |
| `created_at` | `datetime` | no   |         |                                     |
| `updated_at` | `datetime` | no   |         |                                     |

**Associations:**

- `has_many :stock_movements, dependent: :restrict_with_error`
- `has_many :stock_levels, dependent: :delete_all`
- `has_many :inventory_items, through: :stock_levels`

---

### `inventory_items`

Stores master data for all inventory items managed by the system.

| Column              | Type            | Null | Default | Indexes                                 |
| ------------------- | --------------- | ---- | ------- | --------------------------------------- |
| `id`                | `bigint`        | no   |         | Primary Key                             |
| `sku`               | `string`        | no   |         | `index_inventory_items_on_sku` (unique) |
| `name`              | `string`        | no   |         |                                         |
| `unit_cost`         | `decimal(12,2)` | no   |         |                                         |
| `reorder_threshold` | `integer`       | no   | `10`    |                                         |
| `status`            | `integer`       | no   | `0`     |                                         |
| `created_at`        | `datetime`      | no   |         |                                         |
| `updated_at`        | `datetime`      | no   |         |                                         |

**Status Enum Values:** `in_stock`, `low_stock`, `out_of_stock`

**Associations:**

- `has_many :stock_movements, dependent: :restrict_with_error`
- `has_many :stock_levels, dependent: :delete_all`
- `has_many :project_inventories, dependent: :delete_all`
- `has_many :projects, through: :project_inventories`
- `has_many :warehouses, through: :stock_levels`

---

### `stock_levels`

Tracks the quantity of each inventory item in each warehouse (inventory snapshot).

| Column              | Type       | Null | Default | Indexes                                   |
| ------------------- | ---------- | ---- | ------- | ----------------------------------------- |
| `id`                | `bigint`   | no   |         | Primary Key                               |
| `inventory_item_id` | `bigint`   | no   |         | `index_stock_levels_on_inventory_item_id` |
| `warehouse_id`      | `bigint`   | no   |         | `index_stock_levels_on_warehouse_id`      |
| `quantity`          | `integer`  | no   | `0`     |                                           |
| `lock_version`      | `integer`  | no   | `0`     |                                           |
| `created_at`        | `datetime` | no   |         |                                           |
| `updated_at`        | `datetime` | no   |         |                                           |

**Composite Indexes:**

- `index_stock_levels_on_item_and_warehouse` (inventory_item_id, warehouse_id) - unique

**Associations:**

- `belongs_to :inventory_item`
- `belongs_to :warehouse`

---

### `stock_movements`

Tracks all movements (in/out) of inventory items, providing a complete audit trail.

| Column              | Type            | Null | Default | Indexes                                      |
| ------------------- | --------------- | ---- | ------- | -------------------------------------------- |
| `id`                | `bigint`        | no   |         | Primary Key                                  |
| `inventory_item_id` | `bigint`        | no   |         | `index_stock_movements_on_inventory_item_id` |
| `warehouse_id`      | `bigint`        | no   |         | `index_stock_movements_on_warehouse_id`      |
| `movement_type`     | `integer`       | no   | `0`     | `index_stock_movements_on_movement_type`     |
| `quantity`          | `integer`       | no   |         |                                              |
| `unit_cost`         | `decimal(12,2)` | yes  |         |                                              |
| `reference`         | `string`        | yes  |         |                                              |
| `notes`             | `text`          | yes  |         |                                              |
| `employee_id`       | `bigint`        | yes  |         | `index_stock_movements_on_employee_id`       |
| `project_id`        | `bigint`        | yes  |         | `index_stock_movements_on_project_id`        |
| `task_id`           | `bigint`        | yes  |         | `index_stock_movements_on_task_id`           |
| `applied_at`        | `datetime`      | yes  |         | `index_stock_movements_on_applied_at`        |
| `created_at`        | `datetime`      | no   |         | `index_stock_movements_on_created_at`        |
| `updated_at`        | `datetime`      | no   |         |                                              |

**Movement Type Enum Values:** `inbound`, `outbound`, `adjustment`, `allocation`

**Composite Indexes:**

- `index_stock_movements_on_item_and_created_at` (inventory_item_id, created_at)

**Associations:**

- `belongs_to :inventory_item`
- `belongs_to :warehouse`
- `belongs_to :employee, optional: true`
- `belongs_to :project, optional: true`
- `belongs_to :task, optional: true`

---

### `project_inventories`

Links inventory items to projects/tasks, tracking reserved quantities.

| Column              | Type       | Null | Default | Indexes                                          |
| ------------------- | ---------- | ---- | ------- | ------------------------------------------------ |
| `id`                | `bigint`   | no   |         | Primary Key                                      |
| `project_id`        | `bigint`   | no   |         | `index_project_inventories_on_project_id`        |
| `inventory_item_id` | `bigint`   | no   |         | `index_project_inventories_on_inventory_item_id` |
| `quantity`          | `integer`  | no   | `0`     |                                                  |
| `purpose`           | `string`   | yes  |         |                                                  |
| `task_id`           | `bigint`   | yes  |         | `index_project_inventories_on_task_id`           |
| `created_at`        | `datetime` | no   |         |                                                  |
| `updated_at`        | `datetime` | no   |         |                                                  |

**Composite Indexes:**

- `index_project_inventories_on_project_and_item` (project_id, inventory_item_id) - unique

**Associations:**

- `belongs_to :project`
- `belongs_to :inventory_item`
- `belongs_to :task, optional: true`

---

## Background Jobs (Solid Queue)

Tables used by the **Solid Queue** background processing framework for asynchronous job execution.

- `solid_queue_jobs` - Stores job definitions
- `solid_queue_ready_executions` - Ready-to-run job executions
- `solid_queue_scheduled_executions` - Jobs scheduled for future execution
- `solid_queue_claimed_executions` - Jobs claimed by workers
- `solid_queue_blocked_executions` - Jobs waiting on dependencies
- `solid_queue_failed_executions` - Failed job records
- `solid_queue_pauses` - Job queue pause state
- `solid_queue_processes` - Worker process tracking
- `solid_queue_semaphores` - Concurrency control
- `solid_queue_recurring_tasks` - Recurring job definitions
- `solid_queue_recurring_executions` - Recurring job execution history

---

## Foreign Keys

### Core Relationships

- `users` ← `projects` (user_id)
- `users` ← `assignments` (user_id)
- `users` ← `reports` (user_id)

### Project Management

- `projects` ← `tasks` (project_id)
- `projects` ← `reports` (project_id)
- `projects` ← `project_expenses` (project_id)
- `projects` ← `project_files` (project_id)
- `projects` ← `project_inventories` (project_id)
- `tasks` ← `assignments` (task_id)
- `tasks` ← `project_inventories` (task_id)
- `tasks` ← `stock_movements` (task_id)

### HR Module

- `users` ← `hr_employees` (user_id)
- `hr_employees` ← `hr_employees` (manager_id - self-referential)
- `hr_employees` ← `hr_leaves` (employee_id)
- `hr_employees` ← `hr_personal_details` (employee_id)
- `hr_employees` ← `accounting_salaries` (employee_id)
- `hr_employees` ← `stock_movements` (employee_id)

### Accounting Module

- `accounting_salary_batches` ← `accounting_salaries` (batch_id)
- `accounting_salaries` ← `accounting_deductions` (salary_id)

### Inventory Module

- `warehouses` ← `stock_levels` (warehouse_id)
- `warehouses` ← `stock_movements` (warehouse_id)
- `inventory_items` ← `stock_levels` (inventory_item_id)
- `inventory_items` ← `stock_movements` (inventory_item_id)
- `inventory_items` ← `project_inventories` (inventory_item_id)
- `projects` ← `stock_movements` (project_id)

---

## Notes

- **Timestamps:** All tables include `created_at` and `updated_at` for audit tracking
- **Locking:** `stock_levels` uses optimistic locking (`lock_version`) to prevent race conditions during concurrent updates
- **Soft Deletes:** Currently not implemented; use dependent destroy/delete strategies instead
- **Enums:** Rails enums are used for status fields; stored as integers in the database
- **Active Storage:** `project_files` uses Rails Active Storage for file attachment handling via `active_storage_attachments` and `active_storage_blobs`
