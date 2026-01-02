# API Endpoints and Routes

This document outlines the main routes and API endpoints for the Hamzis Systems application. The application follows RESTful conventions.

## Authentication

Authentication is handled by Devise. User registration is disabled. The following routes are provided for user session management:

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/users/sign_in` | `devise/sessions#new` | Show login page |
| `POST` | `/users/sign_in` | `devise/sessions#create` | Create a new session |
| `DELETE`| `/users/sign_out` | `devise/sessions#destroy` | Destroy the session |
| `GET` | `/users/password/new` | `devise/passwords#new` | Show password reset form |
| `POST` | `/users/password` | `devise/passwords#create` | Send password reset email|
| `GET` | `/users/password/edit`| `devise/passwords#edit` | Show password change form|
| `PATCH`| `/users/password` | `devise/passwords#update` | Update user's password |

## Home

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/` | `devise/sessions#new` | Root path, redirects to login |
| `GET` | `/home/index`| `home#index` | Main dashboard |


## Projects

Manages projects.

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/projects` | `projects#index` | List all projects |
| `GET` | `/projects/new` | `projects#new` | Show new project form |
| `POST` | `/projects` | `projects#create` | Create a new project |
| `GET` | `/projects/:id` | `projects#show` | Show a specific project |
| `GET` | `/projects/:id/edit` | `projects#edit` | Show edit project form |
| `PATCH` | `/projects/:id` | `projects#update` | Update a project |
| `DELETE`| `/projects/:id` | `projects#destroy`| Delete a project |

## Tasks

Manages tasks, both globally and within projects.

### Global Tasks

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/tasks` | `tasks#index` | List all tasks |
| `GET` | `/tasks/new`| `tasks#new` | Show new task form |
| `POST` | `/tasks` | `tasks#create` | Create a new task |

### Nested Tasks (within a Project)

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/projects/:project_id/tasks` | `tasks#index` | List all tasks for a project |
| `GET` | `/projects/:project_id/tasks/new` | `tasks#new` | Show new task form for a project |
| `POST` | `/projects/:project_id/tasks` | `tasks#create` | Create a new task for a project |
| `GET` | `/projects/:project_id/tasks/:id` | `tasks#show` | Show a specific task for a project |
| `GET` | `/projects/:project_id/tasks/:id/edit`| `tasks#edit` | Show edit task form for a project |
| `PATCH` | `/projects/:project_id/tasks/:id` | `tasks#update` | Update a task for a project |
| `DELETE`| `/projects/:project_id/tasks/:id` | `tasks#destroy` | Delete a task for a project |

### Custom Task Actions

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `PATCH` | `/projects/:project_id/tasks/:id/in_progress` | `tasks#in_progress`| Mark a task as in progress |
| `PATCH` | `/projects/:project_id/tasks/:id/complete` | `tasks#complete` | Mark a task as complete |

## Reports

Manages reports, both globally and within projects.

### Global Reports

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/reports` | `reports#index` | List all reports |
| `GET` | `/reports/new`| `reports#new` | Show new report form |
| `POST` | `/reports` | `reports#create` | Create a new report |

### Nested Reports (within a Project)

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/projects/:project_id/reports` | `reports#index` | List all reports for a project |
| `GET` | `/projects/:project_id/reports/new` | `reports#new` | Show new report form for a project |
| `POST` | `/projects/:project_id/reports` | `reports#create` | Create a new report for a project |
| `GET` | `/projects/:project_id/reports/:id` | `reports#show` | Show a specific report for a project |
| `GET` | `/projects/:project_id/reports/:id/edit`| `reports#edit` | Show edit report form for a project |
| `PATCH` | `/projects/:project_id/reports/:id` | `reports#update` | Update a report for a project |
| `DELETE`| `/projects/:project_id/reports/:id` | `reports#destroy` | Delete a report for a project |

### Custom Report Actions

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `PATCH` | `/projects/:project_id/reports/:id/submit` | `reports#submit` | Submit a report for review |
| `PATCH` | `/projects/:project_id/reports/:id/review` | `reports#review` | Review a submitted report |

## Accounting

Manages financial transactions, namespaced under `/accounting`.

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/accounting/transactions` | `accounting/transactions#index` | List all transactions |
| `GET` | `/accounting/transactions/new` | `accounting/transactions#new` | Show new transaction form |
| `POST` | `/accounting/transactions` | `accounting/transactions#create` | Create a new transaction |
| `GET` | `/accounting/transactions/:id` | `accounting/transactions#show` | Show a specific transaction |
| `GET` | `/accounting/transactions/:id/edit` | `accounting/transactions#edit` | Show edit transaction form |
| `PATCH` | `/accounting/transactions/:id` | `accounting/transactions#update` | Update a transaction |
| `DELETE`| `/accounting/transactions/:id` | `accounting/transactions#destroy`| Delete a transaction |
| `PATCH` | `/accounting/transactions/:id/mark_paid`| `accounting/transactions#mark_paid`| Mark a transaction as paid |

## HR (Human Resources)

Manages HR-related resources, namespaced under `/hr`.

### Employees

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/hr/employees` | `hr/employees#index` | List all employees |
| `GET` | `/hr/employees/new` | `hr/employees#new` | Show new employee form |
| `POST` | `/hr/employees` | `hr/employees#create`| Create a new employee |
| `GET` | `/hr/employees/:id` | `hr/employees#show` | Show a specific employee |
| `GET` | `/hr/employees/:id/edit` | `hr/employees#edit` | Show edit employee form |
| `PATCH` | `/hr/employees/:id` | `hr/employees#update`| Update an employee |
| `DELETE`| `/hr/employees/:id` | `hr/employees#destroy`| Delete an employee |

### Leave Management

| Method | Path | Controller#Action | Purpose |
| --- | --- | --- | --- |
| `GET` | `/hr/leaves` | `hr/leaves#index` | List all leave requests |
| `GET` | `/hr/leaves/my_leaves` | `hr/leaves#my_leaves` | List leave requests for the current user |
| `GET` | `/hr/leaves/new` | `hr/leaves#new` | Show new leave request form |
| `POST` | `/hr/leaves` | `hr/leaves#create` | Create a new leave request |
| `GET` | `/hr/leaves/:id` | `hr/leaves#show` | Show a specific leave request |
| `GET` | `/hr/leaves/:id/edit` | `hr/leaves#edit` | Show edit leave request form |
| `PATCH` | `/hr/leaves/:id` | `hr/leaves#update` | Update a leave request |
| `DELETE`| `/hr/leaves/:id` | `hr/leaves#destroy`| Delete a leave request |
| `PATCH` | `/hr/leaves/:id/approve` | `hr/leaves#approve` | Approve a leave request |
| `PATCH` | `/hr/leaves/:id/reject` | `hr/leaves#reject` | Reject a leave request |
| `PATCH` | `/hr/leaves/:id/cancel` | `hr/leaves#cancel` | Cancel a leave request |