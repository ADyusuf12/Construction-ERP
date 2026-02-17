# Architecture Overview

This document provides a high-level overview of the Earmark Systems application architecture. The application follows a standard Ruby on Rails Model-View-Controller (MVC) pattern.

## Core Concepts

- **Model-View-Controller (MVC):** The application is structured around the MVC pattern, which separates the application's logic (Model), presentation (View), and user input handling (Controller).
- **Convention over Configuration:** We adhere to Rails conventions to keep the codebase clean, predictable, and easy to navigate.
- **RESTful Design:** The application's routes and controllers are designed to follow REST principles, providing a logical and consistent API.
- **Namespacing:** To organize controllers and models for distinct business domains, the application uses namespacing for modules like **Accounting** and **Human Resources (HR)**.

## Directory Structure

Here is a breakdown of the key directories and their purposes:

- `app/models`: Contains the application's data models (Active Record). These are responsible for business logic and database interaction. Namespaced models are organized in subdirectories (e.g., `app/models/hr/`).
- `app/controllers`: Handles incoming HTTP requests, interacts with models, and renders views. Namespaced controllers are organized in subdirectories (e.g., `app/controllers/accounting/`).
- `app/views`: Contains the application's templates (ERB, Hotwire/Turbo Frames and Streams) that are rendered to the user.
- `app/jobs`: Defines background jobs that can be run asynchronously (using Solid Queue).
- `app/policies`: Contains authorization policies (Pundit) that define user permissions for specific actions.
- `config/`: Holds the application's configuration, including routes, database settings, and initializers.
- `db/`: Contains the database schema, migrations, and seed data.
- `spec/`: Contains all the tests for the application (RSpec).

## Key Features & Models

### Core Project Management

- **`User`**: Represents a user of the application. Handles authentication (via Devise) and roles (CEO, CTO, QS, Site Manager, Engineer, Storekeeper, HR, Accountant, Admin, Client). User self-registration is disabled; admins create accounts.
- **`Project`**: Represents a project with a name, description, status (ongoing/completed), deadline, budget, location, and address. Can be linked to a client.
- **`Task`**: Represents a task within a project with a title, details, status (pending/in_progress/done), due date, and weight for effort estimation.
- **`Assignment`**: A join model connecting `User`s to `Task`s, representing task assignments and accountability.
- **`Report`**: Allows users assigned to tasks to create, submit, and review progress reports associated with a project.
- **`ProjectExpense`**: Tracks expenses related to specific projects for budget tracking. Can be linked to stock movements.
- **`ProjectFile`**: Manages file attachments associated with projects via Active Storage.
- **`ProjectInventory`**: Links inventory items to projects/tasks with reserved quantities, supporting warehouse tracking.

### Business Module

- **`Business::Client`**: Represents external clients/companies that can be linked to projects and users.

### Accounting Module

- **`Accounting::Transaction`**: Represents global financial transactions (invoices/receipts) for the organization.
- **`Accounting::SalaryBatch`**: Represents a batch of salaries (e.g., monthly payroll) to be processed.
- **`Accounting::Salary`**: Represents an employee's salary record within a salary batch, including base pay, allowances, and deductions. Tracks slip delivery via `slip_sent_at`.
- **`Accounting::Deduction`**: Itemized deductions from salaries (tax, pension, loan, health_insurance, other).

### Human Resources (HR) Module

- **`Hr::Employee`**: Represents an employee with hierarchical support via `manager_id` for organizational structure and approval workflows. Auto-generates unique `staff_id` based on hire date.
- **`Hr::Leave`**: Manages leave/time-off requests with complete workflow: employee requests, manager approval/rejection, and cancellation. Automatically deducts leave balance when approved.
- **`Hr::PersonalDetail`**: Stores extended personal and banking information for employees. Validates bank details are present and employee is at least 18 years old.
- **`Hr::AttendanceRecord`**: Tracks employee attendance on projects with check-in/check-out times and status (present/absent/late/on_leave). Unique constraint per employee per day.
- **`Hr::NextOfKin`**: Stores emergency contact information for employees.

### Inventory Module

- **`Warehouse`**: Represents a physical warehouse location where inventory is stored. Supports source and destination warehouse tracking for movements.
- **`InventoryItem`**: Master data for inventory items with SKU, name, unit cost, status (in_stock/low_stock/out_of_stock), reorder threshold, unit of measurement, and default location.
- **`StockLevel`**: Tracks the quantity of each inventory item per warehouse (snapshot/actual inventory). Uses optimistic locking (`lock_version`).
- **`StockMovement`**: Complete audit trail of all inventory movements (inbound/outbound/adjustment/site_delivery) with source/destination warehouse, employee, project, and task references. Supports cancellation with reason tracking.
- **`InventoryManager::MovementApplier`**: Service object that applies stock movements to update stock levels and create project expenses.
- **`InventoryManager::MovementCanceller`**: Service object that reverses stock movements, restoring stock levels and reservations.

---

## Controllers

Controllers handle web requests and coordinate between models and views. Key controllers include:

### Core

- **`ProjectsController`**: CRUD operations for projects
- **`TasksController`**: CRUD operations and status changes for tasks
- **`ReportsController`**: Reporting workflow (create, submit, review)
- **`Dashboard::HomeController`**: Main dashboard with overview metrics
- **`ProjectExpensesController`**: Expense tracking for projects

### Admin & Business

- **`Admin::UsersController`**: User management (admin only)
- **`Business::ClientsController`**: Client/company management

### Accounting

- **`Accounting::TransactionsController`**: Financial transaction management
- **`Accounting::SalaryBatchesController`**: Salary batch processing
- **`Accounting::SalariesController`**: Individual salary management
- **`Accounting::DeductionsController`**: Salary deduction tracking

### Human Resources

- **`Hr::EmployeesController`**: Employee management and directory
- **`Hr::LeavesController`**: Leave request workflow with approval/rejection
- **`Hr::PersonalDetailsController`**: Extended employee information
- **`Hr::AttendanceRecordsController`**: Employee attendance tracking

### Inventory

- **`Inventory::InventoryItemsController`**: Master inventory item management
- **`Inventory::WarehousesController`**: Warehouse location management
- **`Inventory::StockMovementsController`**: Stock movement recording, tracking, and reversal
- **`Inventory::ProjectInventoriesController`**: Project inventory allocation

### Base

- **`ApplicationController`**: Handles authentication, authorization, and shared logic

## Views

Views are built using Rails' standard ERB templates, enhanced with Hotwire for a more interactive, single-page-application-like experience.

- **Hotwire (Turbo & Stimulus):** We use Turbo to speed up page navigation and form submissions, and Stimulus for lightweight JavaScript interactivity.
- **Tailwind CSS:** Styling is handled by the Tailwind CSS framework, which allows for rapid and consistent UI development.
- **Layouts:** The main application layout is defined in `app/views/layouts/application.html.erb`.

## Background Jobs

The application uses **Solid Queue** to run background jobs, such as sending emails, processing data, or handling long-running tasks without blocking the web server. Job definitions are located in the `app/jobs/` directory.

### Creating a Job

To create a new job, you can use the Rails generator:

```bash
rails generate job MyNewJob
```

This will create `app/jobs/my_new_job.rb`. You can then define the job's behavior in the `perform` method.

### Enqueuing a Job

To enqueue a job to be run in the background, you can use `perform_later`:

```ruby
# Enqueue a job to be performed as soon as possible
MyNewJob.perform_later(record)

# Enqueue a job to be performed at a specific time
MyNewJob.set(wait_until: Date.tomorrow.noon).perform_later(record)
```

## Authorization

Authorization is managed by the **Pundit** gem. For each model that requires authorization, a corresponding policy class is created in the `app/policies/` directory. These policies define who can perform which actions (e.g., who can create a project, approve a leave request, etc.).

### How Pundit Works

Pundit uses policy classes that correspond to your models. For a `Project` model, you would have a `ProjectPolicy` class. Each policy class has methods that match the controller actions (e.g., `create?`, `update?`, `destroy?`).

### Example Policy

Here is an example of a simple policy for the `Project` model:

```ruby
# app/policies/project_policy.rb
class ProjectPolicy < ApplicationPolicy
  def show?
    user.admin? || record.users.include?(user)
  end

  def create?
    user.admin? || user.manager?
  end

  def update?
    user.admin? || record.manager == user
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.projects.pluck(:id))
      end
    end
  end
end
```

In your controller, you would use the `authorize` helper to enforce these policies:

```ruby
# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    authorize @project
  end
end
```

## Testing

The application uses **RSpec** as its primary testing framework. Our goal is to have a comprehensive test suite that covers all critical parts of the application.

### Test Structure

- **`spec/models`**: Tests for models, focusing on business logic, validations, and associations.
- **`spec/requests`**: Integration tests that simulate HTTP requests and test the full stack (controllers, views, and models).
- **`spec/factories`**: Factory Bot definitions for creating test data.
- **`spec/policies`**: Tests for Pundit authorization policies.
- **`spec/jobs`**: Tests for background jobs.
- **`spec/system`**: End-to-end tests that simulate user interaction in a real browser, powered by Capybara.

### Running Tests

To run the entire test suite, use the following command:

```bash
bundle exec rspec
```

To run a specific file:

```bash
bundle exec rspec spec/models/project_spec.rb
```

---

_This document is intended to be a living document and should be updated as the application's architecture evolves._
