# API Endpoints and Routes

This document outlines the main routes and API endpoints for the Hamzis Systems application. The application follows RESTful conventions.

## Authentication

Authentication is handled by Devise. The following routes are provided for user session management:

| Method | Path                  | Controller#Action   | Purpose                  |
| ------ | --------------------- | ------------------- | ------------------------ |
| `POST` | `/users`              | `devise/registrations#create` | Create a new user        |
| `GET`  | `/users/sign_in`      | `devise/sessions#new`         | Show login page          |
| `POST` | `/users/sign_in`      | `devise/sessions#create`      | Create a new session     |
| `DELETE`| `/users/sign_out`    | `devise/sessions#destroy`     | Destroy the session      |
| `GET`  | `/users/password/new` | `devise/passwords#new`        | Show password reset form |
| `POST` | `/users/password`     | `devise/passwords#create`     | Send password reset email|
| `GET`  | `/users/password/edit`| `devise/passwords#edit`       | Show password change form|
| `PATCH`| `/users/password`     | `devise/passwords#update`     | Update user's password   |

## Home

| Method | Path        | Controller#Action | Purpose                |
| ------ | ----------- | ----------------- | ---------------------- |
| `GET`  | `/`         | `home#index`      | Main dashboard/root    |
| `GET`  | `/home/index`| `home#index`      | Main dashboard         |


## Projects

Manages projects.

| Method  | Path                       | Controller#Action | Purpose                     |
| ------- | -------------------------- | ----------------- | --------------------------- |
| `GET`   | `/projects`                | `projects#index`  | List all projects           |
| `GET`   | `/projects/new`            | `projects#new`    | Show new project form       |
| `POST`  | `/projects`                | `projects#create` | Create a new project        |
| `GET`   | `/projects/:id`            | `projects#show`   | Show a specific project     |
| `GET`   | `/projects/:id/edit`       | `projects#edit`   | Show edit project form      |
| `PATCH` | `/projects/:id`            | `projects#update` | Update a project            |
| `DELETE`| `/projects/:id`            | `projects#destroy`| Delete a project            |

## Tasks

Manages tasks, both globally and within projects.

### Global Tasks

| Method | Path        | Controller#Action | Purpose                  |
| ------ | ----------- | ----------------- | ------------------------ |
| `GET`  | `/tasks`    | `tasks#index`     | List all tasks           |
| `GET`  | `/tasks/new`| `tasks#new`       | Show new task form       |
| `POST` | `/tasks`    | `tasks#create`    | Create a new task        |

### Nested Tasks (within a Project)

| Method  | Path                                  | Controller#Action | Purpose                               |
| ------- | ------------------------------------- | ----------------- | ------------------------------------- |
| `GET`   | `/projects/:project_id/tasks`         | `tasks#index`     | List all tasks for a project          |
| `GET`   | `/projects/:project_id/tasks/new`     | `tasks#new`       | Show new task form for a project      |
| `POST`  | `/projects/:project_id/tasks`         | `tasks#create`    | Create a new task for a project       |
| `GET`   | `/projects/:project_id/tasks/:id`     | `tasks#show`      | Show a specific task for a project    |
| `GET`   | `/projects/:project_id/tasks/:id/edit`| `tasks#edit`      | Show edit task form for a project     |
| `PATCH` | `/projects/:project_id/tasks/:id`     | `tasks#update`    | Update a task for a project           |
| `DELETE`| `/projects/:project_id/tasks/:id`     | `tasks#destroy`   | Delete a task for a project           |

### Custom Task Actions

| Method  | Path                                        | Controller#Action | Purpose                     |
| ------- | ------------------------------------------- | ----------------- | --------------------------- |
| `PATCH` | `/projects/:project_id/tasks/:id/in_progress` | `tasks#in_progress`| Mark a task as in progress  |
| `PATCH` | `/projects/:project_id/tasks/:id/complete`    | `tasks#complete`   | Mark a task as complete     |

## Transactions

Manages financial transactions.

| Method  | Path                       | Controller#Action | Purpose                         |
| ------- | -------------------------- | ------------------- | ------------------------------- |
| `GET`   | `/transactions`            | `transactions#index`  | List all transactions           |
| `GET`   | `/transactions/new`        | `transactions#new`    | Show new transaction form       |
| `POST`  | `/transactions`            | `transactions#create` | Create a new transaction        |
| `GET`   | `/transactions/:id`        | `transactions#show`   | Show a specific transaction     |
| `GET`   | `/transactions/:id/edit`   | `transactions#edit`   | Show edit transaction form      |
| `PATCH` | `/transactions/:id`        | `transactions#update` | Update a transaction            |
| `DELETE`| `/transactions/:id`        | `transactions#destroy`| Delete a transaction            |
| `PATCH` | `/transactions/:id/mark_paid`| `transactions#mark_paid`| Mark a transaction as paid    |

## HR (Human Resources)

Manages HR-related resources, such as employees.

| Method  | Path                  | Controller#Action | Purpose                    |
| ------- | --------------------- | ----------------- | -------------------------- |
| `GET`   | `/hr/employees`       | `hr/employees#index` | List all employees         |
| `POST`  | `/hr/employees`       | `hr/employees#create`| Create a new employee      |
| `GET`   | `/hr/employees/:id`   | `hr/employees#show`  | Show a specific employee   |
| `PATCH` | `/hr/employees/:id`   | `hr/employees#update`| Update an employee         |
| `DELETE`| `/hr/employees/:id`   | `hr/employees#destroy`| Delete an employee         |
