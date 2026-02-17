# API Endpoints and Routes

This document outlines the main routes and API endpoints for the Earmark Systems application. The application follows RESTful conventions.

**Note:** This is not a JSON API. The application is server-side rendered with Hotwire, so these routes handle web requests and typically respond with HTML.

## Authentication

Authentication is handled by Devise. User registration is disabled. The following routes are provided for user session management:

| Method   | Path                   | Controller#Action         | Purpose                      |
| -------- | ---------------------- | ------------------------- | ---------------------------- |
| `GET`    | `/users/sign_in`       | `devise/sessions#new`     | Show login page              |
| `POST`   | `/users/sign_in`       | `devise/sessions#create`  | Create a new session (login) |
| `DELETE` | `/users/sign_out`      | `devise/sessions#destroy` | Destroy the session (logout) |
| `GET`    | `/users/password/new`  | `devise/passwords#new`    | Show password reset form     |
| `POST`   | `/users/password`      | `devise/passwords#create` | Send password reset email    |
| `GET`    | `/users/password/edit` | `devise/passwords#edit`   | Show password change form    |
| `PATCH`  | `/users/password`      | `devise/passwords#update` | Update user's password       |

## Home

The main dashboard of the application.

| Method | Path         | Controller#Action      | Purpose                       |
| ------ | ------------ | ---------------------- | ----------------------------- |
| `GET`  | `/`          | `devise/sessions#new`  | Root path, redirects to login |
| `GET`  | `/dashboard` | `dashboard/home#index` | Main dashboard                |

## Projects

Manages projects.

| Method   | Path                 | Controller#Action  | Purpose                 |
| -------- | -------------------- | ------------------ | ----------------------- |
| `GET`    | `/projects`          | `projects#index`   | List all projects       |
| `GET`    | `/projects/new`      | `projects#new`     | Show new project form   |
| `POST`   | `/projects`          | `projects#create`  | Create a new project    |
| `GET`    | `/projects/:id`      | `projects#show`    | Show a specific project |
| `GET`    | `/projects/:id/edit` | `projects#edit`    | Show edit project form  |
| `PATCH`  | `/projects/:id`      | `projects#update`  | Update a project        |
| `PUT`    | `/projects/:id`      | `projects#update`  | Update a project        |
| `DELETE` | `/projects/:id`      | `projects#destroy` | Delete a project        |

## Tasks

Manages tasks, both globally and within projects.

### Global Tasks

| Method | Path         | Controller#Action | Purpose            |
| ------ | ------------ | ----------------- | ------------------ |
| `GET`  | `/tasks`     | `tasks#index`     | List all tasks     |
| `GET`  | `/tasks/new` | `tasks#new`       | Show new task form |
| `POST` | `/tasks`     | `tasks#create`    | Create a new task  |

### Nested Tasks (within a Project)

| Method   | Path                                   | Controller#Action | Purpose                            |
| -------- | -------------------------------------- | ----------------- | ---------------------------------- |
| `GET`    | `/projects/:project_id/tasks`          | `tasks#index`     | List all tasks for a project       |
| `GET`    | `/projects/:project_id/tasks/new`      | `tasks#new`       | Show new task form for a project   |
| `POST`   | `/projects/:project_id/tasks`          | `tasks#create`    | Create a new task for a project    |
| `GET`    | `/projects/:project_id/tasks/:id`      | `tasks#show`      | Show a specific task for a project |
| `GET`    | `/projects/:project_id/tasks/:id/edit` | `tasks#edit`      | Show edit task form for a project  |
| `PATCH`  | `/projects/:project_id/tasks/:id`      | `tasks#update`    | Update a task for a project        |
| `PUT`    | `/projects/:project_id/tasks/:id`      | `tasks#update`    | Update a task for a project        |
| `DELETE` | `/projects/:project_id/tasks/:id`      | `tasks#destroy`   | Delete a task for a project        |

### Custom Task Actions

These routes are used to change the status of a task.

| Method  | Path                                          | Controller#Action   | Purpose                    |
| ------- | --------------------------------------------- | ------------------- | -------------------------- |
| `PATCH` | `/projects/:project_id/tasks/:id/in_progress` | `tasks#in_progress` | Mark a task as in progress |
| `PATCH` | `/projects/:project_id/tasks/:id/complete`    | `tasks#complete`    | Mark a task as complete    |

## Reports

Manages reports, both globally and within projects.

### Global Reports

| Method | Path           | Controller#Action | Purpose              |
| ------ | -------------- | ----------------- | -------------------- |
| `GET`  | `/reports`     | `reports#index`   | List all reports     |
| `GET`  | `/reports/new` | `reports#new`     | Show new report form |
| `POST` | `/reports`     | `reports#create`  | Create a new report  |

### Nested Reports (within a Project)

| Method   | Path                                     | Controller#Action | Purpose                              |
| -------- | ---------------------------------------- | ----------------- | ------------------------------------ |
| `GET`    | `/projects/:project_id/reports`          | `reports#index`   | List all reports for a project       |
| `GET`    | `/projects/:project_id/reports/new`      | `reports#new`     | Show new report form for a project   |
| `POST`   | `/projects/:project_id/reports`          | `reports#create`  | Create a new report for a project    |
| `GET`    | `/projects/:project_id/reports/:id`      | `reports#show`    | Show a specific report for a project |
| `GET`    | `/projects/:project_id/reports/:id/edit` | `reports#edit`    | Show edit report form for a project  |
| `PATCH`  | `/projects/:project_id/reports/:id`      | `reports#update`  | Update a report for a project        |
| `PUT`    | `/projects/:project_id/reports/:id`      | `reports#update`  | Update a report for a project        |
| `DELETE` | `/projects/:project_id/reports/:id`      | `reports#destroy` | Delete a report for a project        |

### Custom Report Actions

These routes are used to manage the report workflow.

| Method  | Path                                       | Controller#Action | Purpose                    |
| ------- | ------------------------------------------ | ----------------- | -------------------------- |
| `PATCH` | `/projects/:project_id/reports/:id/submit` | `reports#submit`  | Submit a report for review |
| `PATCH` | `/projects/:project_id/reports/:id/review` | `reports#review`  | Review a submitted report  |

## Accounting

Manages financial transactions, namespaced under `/accounting`.

### Transactions

| Method   | Path                                     | Controller#Action                   | Purpose                     |
| -------- | ---------------------------------------- | ----------------------------------- | --------------------------- |
| `GET`    | `/accounting/transactions`               | `accounting/transactions#index`     | List all transactions       |
| `GET`    | `/accounting/transactions/new`           | `accounting/transactions#new`       | Show new transaction form   |
| `POST`   | `/accounting/transactions`               | `accounting/transactions#create`    | Create a new transaction    |
| `GET`    | `/accounting/transactions/:id`           | `accounting/transactions#show`      | Show a specific transaction |
| `GET`    | `/accounting/transactions/:id/edit`      | `accounting/transactions#edit`      | Show edit transaction form  |
| `PATCH`  | `/accounting/transactions/:id`           | `accounting/transactions#update`    | Update a transaction        |
| `PUT`    | `/accounting/transactions/:id`           | `accounting/transactions#update`    | Update a transaction        |
| `DELETE` | `/accounting/transactions/:id`           | `accounting/transactions#destroy`   | Delete a transaction        |
| `PATCH`  | `/accounting/transactions/:id/mark_paid` | `accounting/transactions#mark_paid` | Mark a transaction as paid  |

Note: Transactions are global (not project-specific) in the current implementation.

### Salary Batches, Salaries, Deductions

| Method   | Path                                                   | Controller#Action                     | Purpose               |
| -------- | ------------------------------------------------------ | ------------------------------------- | --------------------- |
| `GET`    | `/accounting/salary_batches`                           | `accounting/salary_batches#index`     | List salary batches   |
| `GET`    | `/accounting/salary_batches/new`                       | `accounting/salary_batches#new`       | New salary batch form |
| `POST`   | `/accounting/salary_batches`                           | `accounting/salary_batches#create`    | Create salary batch   |
| `GET`    | `/accounting/salary_batches/:id`                       | `accounting/salary_batches#show`      | Show batch            |
| `PATCH`  | `/accounting/salary_batches/:id/mark_paid`             | `accounting/salary_batches#mark_paid` | Mark batch as paid    |
| `GET`    | `/accounting/salary_batches/:salary_batch_id/salaries` | `accounting/salaries#index`           | Salaries in a batch   |
| `GET`    | `/accounting/salaries`                                 | `accounting/salaries#index`           | List salaries         |
| `GET`    | `/accounting/salaries/new`                             | `accounting/salaries#new`             | New salary form       |
| `POST`   | `/accounting/salaries`                                 | `accounting/salaries#create`          | Create salary         |
| `GET`    | `/accounting/salaries/:id`                             | `accounting/salaries#show`            | Show salary           |
| `PATCH`  | `/accounting/salaries/:id`                             | `accounting/salaries#update`          | Update salary         |
| `PATCH`  | `/accounting/salaries/:id/mark_paid`                   | `accounting/salaries#mark_paid`       | Mark salary as paid   |
| `GET`    | `/accounting/deductions`                               | `accounting/deductions#index`         | List deductions       |
| `POST`   | `/accounting/deductions`                               | `accounting/deductions#create`        | Create deduction      |
| `GET`    | `/accounting/deductions/:id`                           | `accounting/deductions#show`          | Show deduction        |
| `PATCH`  | `/accounting/deductions/:id`                           | `accounting/deductions#update`        | Update deduction      |
| `DELETE` | `/accounting/deductions/:id`                           | `accounting/deductions#destroy`       | Delete deduction      |

## HR (Human Resources)

Manages HR-related resources, namespaced under `/hr`.

### Employees

| Method   | Path                                         | Controller#Action          | Purpose                                    |
| -------- | -------------------------------------------- | -------------------------- | ------------------------------------------ |
| `GET`    | `/hr/employees`                              | `hr/employees#index`       | List all employees                         |
| `GET`    | `/hr/employees/new`                          | `hr/employees#new`         | Show new employee form                     |
| `POST`   | `/hr/employees`                              | `hr/employees#create`      | Create a new employee                      |
| `GET`    | `/hr/employees/:id`                          | `hr/employees#show`        | Show a specific employee                   |
| `GET`    | `/hr/employees/:id/edit`                     | `hr/employees#edit`        | Show edit employee form                    |
| `PATCH`  | `/hr/employees/:id`                          | `hr/employees#update`      | Update an employee                         |
| `PUT`    | `/hr/employees/:id`                          | `hr/employees#update`      | Update an employee                         |
| `DELETE` | `/hr/employees/:id`                          | `hr/employees#destroy`     | Delete an employee                         |
| `GET`    | `/hr/employees/:employee_id/personal_detail` | `hr/personal_details#show` | Employee personal detail (nested resource) |

### Leave Management

Manages the leave request and approval process.

| Method   | Path                     | Controller#Action     | Purpose                                              |
| -------- | ------------------------ | --------------------- | ---------------------------------------------------- |
| `GET`    | `/hr/leaves`             | `hr/leaves#index`     | List all leave requests (for managers/admins)        |
| `GET`    | `/hr/leaves/my_leaves`   | `hr/leaves#my_leaves` | List leave requests for the current user             |
| `GET`    | `/hr/leaves/new`         | `hr/leaves#new`       | Show new leave request form                          |
| `POST`   | `/hr/leaves`             | `hr/leaves#create`    | Create a new leave request                           |
| `GET`    | `/hr/leaves/:id`         | `hr/leaves#show`      | Show a specific leave request                        |
| `GET`    | `/hr/leaves/:id/edit`    | `hr/leaves#edit`      | Show edit leave request form                         |
| `PATCH`  | `/hr/leaves/:id`         | `hr/leaves#update`    | Update a leave request                               |
| `PUT`    | `/hr/leaves/:id`         | `hr/leaves#update`    | Update a leave request                               |
| `DELETE` | `/hr/leaves/:id`         | `hr/leaves#destroy`   | Delete a leave request                               |
| `PATCH`  | `/hr/leaves/:id/approve` | `hr/leaves#approve`   | Approve a leave request (for managers)               |
| `PATCH`  | `/hr/leaves/:id/reject`  | `hr/leaves#reject`    | Reject a leave request (for managers)                |
| `PATCH`  | `/hr/leaves/:id/cancel`  | `hr/leaves#cancel`    | Cancel a leave request (for the user who created it) |

---

## Inventory

Manages inventory items, stock movements, and warehouse operations, namespaced under `/inventory`.

### Inventory Items

| Method   | Path                                  | Controller#Action                   | Purpose                        |
| -------- | ------------------------------------- | ----------------------------------- | ------------------------------ |
| `GET`    | `/inventory/inventory_items`          | `inventory/inventory_items#index`   | List all inventory items       |
| `GET`    | `/inventory/inventory_items/new`      | `inventory/inventory_items#new`     | Show new inventory item form   |
| `POST`   | `/inventory/inventory_items`          | `inventory/inventory_items#create`  | Create a new inventory item    |
| `GET`    | `/inventory/inventory_items/:id`      | `inventory/inventory_items#show`    | Show a specific inventory item |
| `GET`    | `/inventory/inventory_items/:id/edit` | `inventory/inventory_items#edit`    | Show edit inventory item form  |
| `PATCH`  | `/inventory/inventory_items/:id`      | `inventory/inventory_items#update`  | Update an inventory item       |
| `PUT`    | `/inventory/inventory_items/:id`      | `inventory/inventory_items#update`  | Update an inventory item       |
| `DELETE` | `/inventory/inventory_items/:id`      | `inventory/inventory_items#destroy` | Delete an inventory item       |

### Stock Movements

| Method   | Path                                                                     | Controller#Action                   | Purpose                       |
| -------- | ------------------------------------------------------------------------ | ----------------------------------- | ----------------------------- |
| `GET`    | `/inventory/inventory_items/:inventory_item_id/stock_movements`          | `inventory/stock_movements#index`   | List stock movements for item |
| `GET`    | `/inventory/inventory_items/:inventory_item_id/stock_movements/new`      | `inventory/stock_movements#new`     | New stock movement form       |
| `POST`   | `/inventory/inventory_items/:inventory_item_id/stock_movements`          | `inventory/stock_movements#create`  | Create stock movement         |
| `GET`    | `/inventory/inventory_items/:inventory_item_id/stock_movements/:id`      | `inventory/stock_movements#show`    | Show stock movement detail    |
| `GET`    | `/inventory/inventory_items/:inventory_item_id/stock_movements/:id/edit` | `inventory/stock_movements#edit`    | Edit stock movement form      |
| `PATCH`  | `/inventory/inventory_items/:inventory_item_id/stock_movements/:id`      | `inventory/stock_movements#update`  | Update stock movement         |
| `PUT`    | `/inventory/inventory_items/:inventory_item_id/stock_movements/:id`      | `inventory/stock_movements#update`  | Update stock movement         |
| `DELETE` | `/inventory/inventory_items/:inventory_item_id/stock_movements/:id`      | `inventory/stock_movements#destroy` | Delete stock movement         |

### Warehouses

| Method   | Path                             | Controller#Action              | Purpose                  |
| -------- | -------------------------------- | ------------------------------ | ------------------------ |
| `GET`    | `/inventory/warehouses`          | `inventory/warehouses#index`   | List all warehouses      |
| `GET`    | `/inventory/warehouses/new`      | `inventory/warehouses#new`     | Show new warehouse form  |
| `POST`   | `/inventory/warehouses`          | `inventory/warehouses#create`  | Create a new warehouse   |
| `GET`    | `/inventory/warehouses/:id`      | `inventory/warehouses#show`    | Show a warehouse         |
| `GET`    | `/inventory/warehouses/:id/edit` | `inventory/warehouses#edit`    | Show edit warehouse form |
| `PATCH`  | `/inventory/warehouses/:id`      | `inventory/warehouses#update`  | Update a warehouse       |
| `PUT`    | `/inventory/warehouses/:id`      | `inventory/warehouses#update`  | Update a warehouse       |
| `DELETE` | `/inventory/warehouses/:id`      | `inventory/warehouses#destroy` | Delete a warehouse       |

### Project Inventories

Project inventories are managed via form submissions in projects and through API endpoints for dynamic management.

| Method   | Path                                      | Controller#Action                       | Purpose                       |
| -------- | ----------------------------------------- | --------------------------------------- | ----------------------------- |
| `POST`   | `/inventory/project_inventories`          | `inventory/project_inventories#create`  | Allocate inventory to project |
| `GET`    | `/inventory/project_inventories/:id/edit` | `inventory/project_inventories#edit`    | Show edit form                |
| `PATCH`  | `/inventory/project_inventories/:id`      | `inventory/project_inventories#update`  | Update allocation             |
| `PUT`    | `/inventory/project_inventories/:id`      | `inventory/project_inventories#update`  | Update allocation             |
| `DELETE` | `/inventory/project_inventories/:id`      | `inventory/project_inventories#destroy` | Remove allocation             |

---

## Project Expenses

Manages expense tracking for projects.

| Method   | Path                                              | Controller#Action          | Purpose               |
| -------- | ------------------------------------------------- | -------------------------- | --------------------- |
| `GET`    | `/projects/:project_id/project_expenses`          | `project_expenses#index`   | List project expenses |
| `GET`    | `/projects/:project_id/project_expenses/new`      | `project_expenses#new`     | Show new expense form |
| `POST`   | `/projects/:project_id/project_expenses`          | `project_expenses#create`  | Create expense        |
| `GET`    | `/projects/:project_id/project_expenses/:id`      | `project_expenses#show`    | Show expense detail   |
| `GET`    | `/projects/:project_id/project_expenses/:id/edit` | `project_expenses#edit`    | Edit expense form     |
| `PATCH`  | `/projects/:project_id/project_expenses/:id`      | `project_expenses#update`  | Update expense        |
| `PUT`    | `/projects/:project_id/project_expenses/:id`      | `project_expenses#update`  | Update expense        |
| `DELETE` | `/projects/:project_id/project_expenses/:id`      | `project_expenses#destroy` | Delete expense        |

---

## Notes and Implementation Details

- **Authentication**: Most controllers call `before_action :authenticate_user!` — endpoints require a signed-in user.
- **Authorization**: Pundit is used (`policy_scope` in index actions, `authorize` in show/create/update/destroy and custom actions). Example: `ProjectPolicy` controls project visibility and actions.
- **Turbo Streams**:
  - Several actions respond to Turbo Stream (e.g., `reports#submit`, `reports#review`, `tasks#in_progress`, `tasks#complete`, `accounting/salaries#mark_paid`). Ensure corresponding `.turbo_stream.erb` templates or partials exist and that row partials accept required locals (for example `row_class` for zebra striping).
- **Nested vs Global**:
  - `tasks` and `reports` are available both globally and nested under `projects`. Controllers handle both contexts (build under `@project` when `project_id` present).
- **No JSON API**:
  - The app is HTML/Turbo-first. Controllers may respond to `format.html` and `format.turbo_stream`; JSON responses are present only where controllers explicitly render JSON (e.g., `projects#create`/`update` include JSON branches).
- **Root path**:
  - Root is configured to Devise sign-in page; after sign-in users are redirected to the dashboard (`dashboard/home#index`).

---
