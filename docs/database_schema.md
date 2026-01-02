# Database Schema Overview

This document provides an overview of the database schema for the Hamzis Systems application. The schema is defined in `db/schema.rb`.

## Table Reference

Here is a summary of the tables and their purposes.

---

### `users`

Stores user account information, including credentials and roles.

| Column | Type | Null | Default | Indexes |
| --- | --- | --- | --- | --- |
| `id` | `bigint` | no | | Primary Key |
| `email` | `string` | no | `""` | `index_users_on_email` (unique) |
| `encrypted_password` | `string` | no | `""` | |
| `reset_password_token` | `string` | yes | | `index_users_on_reset_password_token` (unique) |
| `reset_password_sent_at`| `datetime`| yes | | |
| `remember_created_at` | `datetime`| yes | | |
| `role` | `integer` | yes | | |
| `created_at` | `datetime`| no | | |
| `updated_at` | `datetime`| no | | |

**Associations:**
- `has_many :projects`
- `has_many :assignments`
- `has_many :tasks, through: :assignments`
- `has_one :hr_employee`
- `has_many :reports`

---

### `projects`

Stores information about projects.

| Column | Type | Null | Default | Indexes |
| --- | --- | --- | --- | --- |
| `id` | `bigint`| no | | Primary Key |
| `name` | `string`| yes | | |
| `description`| `text` | yes | | |
| `status` | `integer`| no | `0` | |
| `deadline` | `datetime`| yes| | |
| `budget` | `decimal`| yes | | |
| `progress` | `integer`| no | `0` | |
| `user_id` | `bigint`| no | | `index_projects_on_user_id` |
| `created_at`| `datetime`| no | | |
| `updated_at`| `datetime`| no | | |

**Associations:**
- `belongs_to :user`
- `has_many :tasks`
- `has_many :transactions`
- `has_many :reports`

---

### `tasks`

Stores information about tasks, which belong to projects.

| Column | Type | Null | Default | Indexes |
| --- | --- | --- | --- | --- |
| `id` | `bigint` | no | | Primary Key |
| `title` | `string` | no | | |
| `details` | `text` | yes | | |
| `status` | `integer` | no | `0` | |
| `due_date` | `datetime` | yes | | |
| `weight` | `integer` | no | `1` | |
| `project_id`| `bigint` | no | | `index_tasks_on_project_id` |
| `created_at`| `datetime`| no | | |
| `updated_at`| `datetime`| no | | |

**Associations:**
- `belongs_to :project`
- `has_many :assignments`
- `has_many :users, through: :assignments`

---

### `assignments`

A join table that assigns users to tasks.

| Column | Type | Null | Default | Indexes |
| --- | --- | --- | --- | --- |
| `id` | `bigint`| no | | Primary Key |
| `task_id`| `bigint`| no | | `index_assignments_on_task_id` |
| `user_id`| `bigint`| no | | `index_assignments_on_user_id` |
| `created_at`| `datetime`| no| | |
| `updated_at`| `datetime`| no| | |

**Associations:**
- `belongs_to :task`
- `belongs_to :user`

---

### `transactions`

Stores financial transactions related to projects.

| Column | Type | Null | Default | Indexes |
| --- | --- | --- | --- | --- |
| `id` | `bigint`| no | | Primary Key |
| `date` | `date` | no | | `index_transactions_on_project_id_and_date` |
| `description` | `string`| no | | |
| `amount` | `decimal`| no | | |
| `transaction_type`| `integer`| no | `0` | `index_transactions_on_transaction_type` |
| `status` | `integer`| no | `0` | `index_transactions_on_status` |
| `reference` | `string`| yes | | |
| `notes` | `text` | yes | | |
| `project_id` | `bigint`| no | | `index_transactions_on_project_id` |
| `created_at` | `datetime`| no | | |
| `updated_at` | `datetime`| no | | |

**Associations:**
- `belongs_to :project`

---

### `hr_employees`

Stores information about employees for the HR module.

| Column | Type | Null | Default | Indexes |
| --- | --- | --- | --- | --- |
| `id` | `bigint` | no | | Primary Key |
| `hamzis_id` | `string` | no | | `index_hr_employees_on_hamzis_id` (unique) |
| `department` | `string` | yes | | |
| `position_title` | `string` | yes | | |
| `hire_date` | `date` | yes | | |
| `status` | `integer` | yes | `0` | |
| `leave_balance` | `integer` | yes | `0` | |
| `performance_score`| `decimal`| yes | | |
| `user_id` | `bigint` | yes | | `index_hr_employees_on_user_id` |
| `manager_id` | `bigint` | yes | | `index_hr_employees_on_manager_id` |
| `created_at` | `datetime`| no | | |
| `updated_at` | `datetime`| no | | |

**Associations:**
- `belongs_to :user` (optional)
- `belongs_to :manager, class_name: 'HrEmployee', optional: true`
- `has_many :subordinates, class_name: 'HrEmployee', foreign_key: 'manager_id'`
- `has_many :leaves, class_name: 'HrLeave', foreign_key: 'employee_id'`

---

### `hr_leaves`

Stores leave requests for employees.

| Column | Type | Null | Default | Indexes |
| --- | --- | --- | --- | --- |
| `id` | `bigint` | no | | Primary Key |
| `employee_id` | `bigint` | no | | `index_hr_leaves_on_employee_id` |
| `manager_id` | `bigint` | yes | | `index_hr_leaves_on_manager_id` |
| `start_date` | `date` | no | | |
| `end_date` | `date` | no | | |
| `reason` | `text` | no | | |
| `status` | `integer` | no | `0` | |
| `created_at` | `datetime`| no | | |
| `updated_at` | `datetime`| no | | |

**Associations:**
- `belongs_to :employee, class_name: 'HrEmployee'`
- `belongs_to :manager, class_name: 'HrEmployee', optional: true`

---

### `reports`

Stores project reports.

| Column | Type | Null | Default | Indexes |
| --- | --- | --- | --- | --- |
| `id` | `bigint` | no | | Primary Key |
| `project_id` | `bigint` | no | | `index_reports_on_project_id` |
| `user_id` | `bigint` | no | | `index_reports_on_user_id` |
| `report_date` | `date` | no | | |
| `report_type` | `integer` | no | `0` | |
| `status` | `integer` | no | `0` | |
| `progress_summary` | `text` | yes | | |
| `issues` | `text` | yes | | |
| `next_steps` | `text` | yes | | |
| `created_at` | `datetime`| no | | |
| `updated_at` | `datetime`| no | | |

**Associations:**
- `belongs_to :project`
- `belongs_to :user`

## Foreign Keys

- `assignments` -> `tasks`
- `assignments` -> `users`
- `hr_employees` -> `users`
- `hr_employees` -> `hr_employees` (as manager)
- `hr_leaves` -> `hr_employees` (as employee)
- `hr_leaves` -> `hr_employees` (as manager)
- `projects` -> `users`
- `reports` -> `projects`
- `reports` -> `users`
- `tasks` -> `projects`
- `transactions` -> `projects`