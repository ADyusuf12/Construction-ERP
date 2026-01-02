# Hamzis Systems

**Hamzis Systems** is a comprehensive project management and business administration application designed to streamline workflows, manage projects, track tasks, and handle internal resources like human resources and financial transactions.

![App Screenshot Placeholder](https://via.placeholder.com/800x450.png?text=Hamzis+Systems+UI)
_A placeholder for the main application dashboard or a key feature._

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Documentation](#documentation)
- [Technology Stack](#technology-stack)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)
- [Running Tests](#running-tests)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview

This application provides a centralized platform for managing core business operations. It is built with a modern, robust, and scalable technology stack, making it suitable for small to medium-sized teams. The system is designed with clear user roles and permissions, ensuring data security and integrity.

## Features

- **User Authentication:** Secure user login using Devise. (Note: Self-registration is disabled).
- **Role-Based Authorization:** Granular permissions for different user roles (e.g., admin, manager, employee) using Pundit.
- **Project Management:** Create, update, and track projects from inception to completion, including budget, progress, and deadlines.
- **Task Tracking:** Assign and monitor tasks within projects, with status updates and priorities.
- **Project Reporting System:** A complete workflow for creating, submitting, and reviewing project reports (e.g., daily or weekly updates).
- **Human Resources Module:**
    - Manage employee records and hierarchical relationships (manager/subordinate).
    - A full **Leave Management System** for employees to request leave and managers to approve or reject it.
- **Accounting Module:** Log, categorize, and manage financial transactions associated with projects.

## Documentation

For a deeper understanding of the application's architecture, APIs, and features, please refer to our detailed documentation:

- **[Architecture Overview](./docs/architecture.md)**
- **[Database Schema](./docs/database_schema.md)**
- **[API Endpoints](./docs/api_endpoints.md)**
- **[Frontend Guide](./docs/frontend_guide.md)**
- **Feature Guides:**
    - **[HR Leave Management](./docs/leave_management_guide.md)**
    - **[Project Reporting](./docs/project_reporting_guide.md)**

## Technology Stack

This project is built with a modern Rails 8 stack:

- **Backend:** Ruby on Rails 8.0.4
- **Database:** PostgreSQL
- **Authentication:** Devise
- **Authorization:** Pundit
- **Frontend:** Hotwire (Turbo & Stimulus), Tailwind CSS
- **Background Jobs:** Solid Queue
- **Caching:** Solid Cache
- **Websockets:** Solid Cable
- **Testing:** RSpec, Factory Bot, Faker, Capybara
- **Linting:** RuboCop (with `rubocop-rails-omakase`)
- **Deployment:** Kamal

## Setup and Installation

Follow these steps to get the application running locally.

### Prerequisites

- Ruby 3.3.0 or later
- Node.js & Yarn
- PostgreSQL

### Installation Steps

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/hamzis_systems.git
    cd hamzis_systems
    ```

2.  **Install dependencies:**

    ```bash
    bundle install
    npm install
    ```

3.  **Set up the database:**
    Make sure your `config/database.yml` is configured correctly for your local PostgreSQL instance. Then run:

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed # Optional: if you have seed data
    ```

4.  **Run the application:**
    ```bash
    bin/dev
    ```
    The application will be available at `http://localhost:3000`.

## Usage

- Access the application at `http://localhost:3000`.
- Log in with existing credentials. User accounts must be created by an administrator.

## Running Tests

To ensure code quality and stability, run the test suite:

```bash
bundle exec rspec
```

You can also run the RuboCop linter to check for style violations:

```bash
bundle exec rubocop
```

And run Brakeman to scan for security vulnerabilities:

```bash
bundle exec brakeman
```

## Deployment

This application is configured for deployment using [Kamal](https://kamal-deploy.org/). The deployment configuration is located in `config/deploy.yml`.

To deploy the application, ensure you have access to the target server and run:

```bash
kamal deploy
```

## Contributing

Contributions are welcome! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Abdullahi Yusuf - adyusuf68@gmail.com

Project Link: [https://github.com/ADyusuf12/hamzis_systems](https://github.com/ADyusuf12/hamzis_systems)