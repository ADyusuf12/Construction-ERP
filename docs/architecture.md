# Architecture Overview

This document provides a high-level overview of the Hamzis Systems application architecture. The application follows a standard Ruby on Rails Model-View-Controller (MVC) pattern.

## Core Concepts

- **Model-View-Controller (MVC):** The application is structured around the MVC pattern, which separates the application's logic (Model), presentation (View), and user input handling (Controller).
- **Convention over Configuration:** We adhere to Rails conventions to keep the codebase clean, predictable, and easy to navigate.
- **RESTful Design:** The application's routes and controllers are designed to follow REST principles, providing a logical and consistent API.

## Directory Structure

Here is a breakdown of the key directories and their purposes:

- `app/models`: Contains the application's data models (Active Record). These are responsible for business logic and database interaction.
- `app/controllers`: Handles incoming HTTP requests, interacts with models, and renders views.
- `app/views`: Contains the application's templates (ERB, Hotwire/Turbo Frames and Streams) that are rendered to the user.
- `app/jobs`: Defines background jobs that can be run asynchronously (using Solid Queue).
- `app/policies`: Contains authorization policies (Pundit) that define user permissions for specific actions.
- `config/`: Holds the application's configuration, including routes, database settings, and initializers.
- `db/`: Contains the database schema, migrations, and seed data.
- `spec/`: Contains all the tests for the application (RSpec).

## Models

The core models of the application are:

- **`User`**: Represents a user of the application. Handles authentication and roles.
- **`Project`**: Represents a project with a name, description, status, and other details.
- **`Task`**: Represents a task within a project. It has a description, status, weight, and can be assigned to users.
- **`Assignment`**: A join model that connects `User`s to `Task`s, representing task assignments.
- **`Transaction`**: Represents a financial transaction.
- **`Hr::Employee`**: Represents an employee in the HR module (namespaced under `Hr`).

These models use Active Record associations (`has_many`, `belongs_to`, etc.) to define their relationships.

## Controllers

Controllers are responsible for handling web requests and responding with the appropriate data or view. Some of the key controllers include:

- **`ProjectsController`**: Handles CRUD operations for projects.
- **`TasksController`**: Handles CRUD operations for tasks.
- **`TransactionsController`**: Manages financial transactions.
- **`HomeController`**: Renders the main dashboard or landing page.

Application-wide logic is handled in `ApplicationController`, which serves as the base for all other controllers.

## Views

Views are built using Rails' standard ERB templates, enhanced with Hotwire for a more interactive, single-page-application-like experience.

- **Hotwire (Turbo & Stimulus):** We use Turbo to speed up page navigation and form submissions, and Stimulus for lightweight JavaScript interactivity.
- **Tailwind CSS:** Styling is handled by the Tailwind CSS framework, which allows for rapid and consistent UI development.
- **Layouts:** The main application layout is defined in `app/views/layouts/application.html.erb`.

## Background Jobs

The application uses **Solid Queue** to run background jobs, such as sending emails, processing data, or handling long-running tasks without blocking the web server. Job definitions are located in the `app/jobs/` directory.

## Authorization

Authorization is managed by the **Pundit** gem. For each model that requires authorization, a corresponding policy class is created in the `app/policies/` directory. These policies define who can perform which actions (e.g., who can create a project, edit a task, etc.).

---

*This document is intended to be a living document and should be updated as the application's architecture evolves.*
