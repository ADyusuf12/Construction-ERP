# Frontend Development Guide

This document provides an overview of the frontend architecture and conventions used in the Hamzis Systems application. It is intended for developers who will be working on the user interface.

## Core Technologies

The frontend is built on a modern, Rails-centric stack that minimizes custom JavaScript while providing a fast, responsive user experience.

- **[Hotwire](https://hotwired.dev/):** The core of our frontend philosophy. Hotwire allows us to build modern, single-page-application-like experiences with minimal JavaScript. It consists of:
    - **Turbo:** Accelerates navigation and form submissions by fetching HTML fragments from the server instead of full page reloads. We use Turbo Frames for targeted UI updates and Turbo Streams for broadcasting server-side changes to clients.
    - **Stimulus:** A modest JavaScript framework for adding client-side interactivity where needed. We use it for things like toggling menus, confirming actions, and other small-scale DOM manipulations.
- **[Tailwind CSS](https://tailwindcss.com/):** A utility-first CSS framework that allows us to build custom designs without writing custom CSS. All styling is done directly in the markup via utility classes.

## Structure & Conventions

- **Views (`app/views`):** All view templates are written in ERB (`.html.erb`). The directory is organized by controller, following Rails conventions.
- **Layouts (`app/views/layouts`):** The primary application layout is `application.html.erb`. This file contains the main `<html>`, `<head>`, and `<body>` structure, and it's where our CSS and JavaScript assets are included.
- **Partials (`_partial.html.erb`):** We extensively use partials to keep our views DRY (Don't Repeat Yourself). Partials are used for forms, table rows, and other reusable UI components. They are typically stored in the corresponding view directory (e.g., `app/views/reports/_form.html.erb`).
- **Stimulus Controllers (`app/javascript/controllers`):** All custom client-side logic is encapsulated in Stimulus controllers. These controllers are automatically loaded and connected to the DOM based on the `data-controller` attribute.

## Styling with Tailwind CSS

- **Configuration:** The Tailwind CSS configuration is located at `config/tailwind.config.js`. This file defines our color palette, fonts, and other design tokens.
- **Customizations:** We have a custom color palette defined under the `hamzis-` prefix (e.g., `bg-hamzis-copper`, `text-hamzis-brown`). These colors should be used to maintain a consistent look and feel.
- **Utility-First:** Instead of writing CSS files, we apply styles directly in the HTML. For example, a styled button might look like this:
  ```html
  <button class="px-4 py-2 rounded bg-hamzis-copper text-hamzis-white hover:bg-hamzis-black transition">
    Click Me
  </button>
  ```

## Interactivity with Hotwire

### Turbo Frames

Turbo Frames (`<turbo-frame>`) are used to scope navigation and updates to a specific part of the page. For example, editing an item in a list might only reload the frame containing that item, not the entire page.

### Turbo Streams

Turbo Streams are used for asynchronous, out-of-band updates. When a user performs an action (like approving a leave request), the server can send a Turbo Stream response that updates the UI on the fly for all relevant users. This is heavily used in our new features for a real-time experience.

Examples can be seen in:
- `app/views/hr/leaves/approve.turbo_stream.erb`
- `app/views/reports/submit.turbo_stream.erb`

## Feature-Specific UI Guides

As the application grows, we are documenting the UI and workflow for specific features. These guides serve as excellent examples of our frontend architecture in practice.

- **[HR Leave Management System Guide](./leave_management_guide.md)**: Details the UI and workflow for requesting and approving leave.
- **[Project Reporting System Guide](./project_reporting_guide.md)**: Details the UI and workflow for creating and reviewing project reports.
