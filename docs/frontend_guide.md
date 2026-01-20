# Frontend Guide

This document provides a comprehensive overview of the frontend architecture, styling approach, component structure, and development guidelines for the Hamzis Systems application.

## Table of Contents

- [Overview](#overview)
- [Technology Stack](#technology-stack)
- [Directory Structure](#directory-structure)
- [Styling & Design](#styling--design)
- [Layout & Components](#layout--components)
- [JavaScript Controllers](#javascript-controllers)
- [Forms & Interactivity](#forms--interactivity)
- [Best Practices](#best-practices)

---

## Overview

The Hamzis Systems frontend is built with modern, interactive technologies that prioritize user experience while maintaining clean, maintainable code. The application uses server-side rendering with Hotwire for dynamic updates, eliminating the need for a separate SPA framework.

### Key Principles

- **Server-First Rendering:** HTML is rendered server-side, reducing JavaScript complexity
- **Progressive Enhancement:** Interactivity is layered on top of semantic HTML
- **Responsive Design:** Mobile-first approach using Tailwind CSS
- **Dark Mode Support:** Full light/dark theme toggle throughout the application
- **Accessibility:** Semantic HTML, ARIA labels, and keyboard navigation support

---

## Technology Stack

### Core Technologies

- **HTML/ERB:** Rails view templates with embedded Ruby for dynamic content
- **Tailwind CSS:** Utility-first CSS framework for rapid UI development
- **Hotwire:**
  - **Turbo:** Fast navigation and form submissions via AJAX
  - **Stimulus:** Lightweight JavaScript framework for controller logic
- **JavaScript:** Vanilla JS with Stimulus controllers for interactivity
- **Rails Asset Pipeline:** CSS/JS bundling and minification

### Version Information

- Rails 8.0.4 with CSS/JS bundling via Importmap
- Tailwind CSS 3.x via the `tailwindcss-rails` gem
- Hotwire (Turbo & Stimulus) included by default in Rails 8

---

## Directory Structure

### Views Organization

```
app/views/
├── layouts/
│   ├── application.html.erb    # Main application layout with sidebar and footer
│   └── mailer.html.erb         # Email template layout
├── shared/
│   ├── _sidebar.html.erb       # Main navigation sidebar
│   ├── sidebar/
│   │   ├── _operations.html.erb    # Project/Task/Report navigation
│   │   ├── _accounting.html.erb    # Accounting module navigation
│   │   ├── _hr.html.erb            # HR module navigation
│   │   └── _inventory.html.erb     # Inventory module navigation
│   ├── _flash.html.erb         # Flash message alerts
│   ├── _auth_links.html.erb    # Authentication links
│   └── _confirm_delete_modal.html.erb # Reusable delete confirmation
├── dashboard/
│   └── home/
│       └── index.html.erb      # Main dashboard overview
├── projects/
│   ├── index.html.erb          # Projects list
│   ├── show.html.erb           # Project detail view
│   ├── new.html.erb            # New project form
│   ├── edit.html.erb           # Edit project form
│   ├── _form.html.erb          # Shared project form partial
│   ├── _projects_table.html.erb # Projects table component
│   ├── _projects_summary.html.erb # KPI summary card
│   └── tabs/
│       ├── _tasks_tab.html.erb # Nested tasks tab
│       ├── _reports_tab.html.erb # Project reports tab
│       ├── _expenses_tab.html.erb # Project expenses tab
│       └── _inventory_tab.html.erb # Project inventory tab
├── tasks/
│   ├── index.html.erb          # All tasks view
│   ├── show.html.erb           # Task detail
│   ├── new.html.erb            # New task form
│   ├── edit.html.erb           # Edit task form
│   ├── _form.html.erb          # Shared task form
│   ├── _task_row.html.erb      # Table row component
│   ├── _task_table_header.html.erb # Table header
│   └── _dashboard_summary.html.erb # Task metrics
├── reports/
│   ├── index.html.erb          # Reports list
│   ├── show.html.erb           # Report detail
│   ├── new.html.erb            # New report form
│   ├── edit.html.erb           # Edit report form
│   ├── _form.html.erb          # Shared report form
│   ├── _report.html.erb        # Report card component
│   ├── _report_row.html.erb    # Table row component
│   ├── _reports_table.html.erb # Reports table
│   ├── _dashboard_summary.html.erb # Reports summary
│   ├── submit.turbo_stream.erb # Turbo Stream: submit report
│   └── review.turbo_stream.erb # Turbo Stream: review report
├── project_expenses/
│   ├── index.html.erb          # Project expenses list
│   ├── _form.html.erb          # Expense form
│   └── _expense_row.html.erb   # Table row component
├── accounting/
│   ├── transactions/
│   │   ├── index.html.erb      # Transactions list
│   │   ├── show.html.erb       # Transaction detail
│   │   ├── _form.html.erb      # Transaction form
│   │   └── _transaction_row.html.erb
│   ├── salary_batches/
│   │   ├── index.html.erb      # Salary batches list
│   │   ├── show.html.erb       # Batch detail with salaries
│   │   ├── _form.html.erb      # Create batch form
│   │   └── _batch_card.html.erb
│   ├── salaries/
│   │   ├── index.html.erb      # All salaries view
│   │   ├── show.html.erb       # Individual salary
│   │   ├── _form.html.erb      # Salary form
│   │   ├── _salary_row.html.erb # Table row
│   │   └── mark_paid.turbo_stream.erb # Mark as paid
│   └── deductions/
│       ├── _form.html.erb      # Deduction form
│       └── _deduction_row.html.erb
├── hr/
│   ├── employees/
│   │   ├── index.html.erb      # Employee directory
│   │   ├── show.html.erb       # Employee profile
│   │   ├── edit.html.erb       # Edit employee
│   │   ├── _form.html.erb      # Employee form
│   │   ├── _employee_row.html.erb # Table row
│   │   └── personal_details/
│   │       ├── show.html.erb   # Personal details view
│   │       └── _form.html.erb  # Personal details form
│   └── leaves/
│       ├── index.html.erb      # All leaves (admin view)
│       ├── my_leaves.html.erb  # Employee's leaves
│       ├── show.html.erb       # Leave detail
│       ├── new.html.erb        # New leave request
│       ├── edit.html.erb       # Edit leave request
│       ├── _form.html.erb      # Leave form
│       ├── _leave_row.html.erb # Table row
│       ├── approve.turbo_stream.erb # Approve action
│       ├── reject.turbo_stream.erb  # Reject action
│       └── cancel.turbo_stream.erb  # Cancel action
├── inventory/
│   ├── inventory_items/
│   │   ├── index.html.erb      # Inventory master list
│   │   ├── show.html.erb       # Item detail with stock levels
│   │   ├── new.html.erb        # New item form
│   │   ├── edit.html.erb       # Edit item
│   │   ├── _form.html.erb      # Item form
│   │   ├── _inventory_table.html.erb # Items table
│   │   ├── _inventory_row.html.erb # Table row
│   │   └── _summary.html.erb   # Item KPI card
│   ├── stock_movements/
│   │   ├── index.html.erb      # Stock movements list
│   │   ├── new.html.erb        # New movement form
│   │   ├── edit.html.erb       # Edit movement
│   │   └── _form.html.erb      # Movement form
│   ├── warehouses/
│   │   ├── index.html.erb      # Warehouse list
│   │   ├── show.html.erb       # Warehouse detail
│   │   ├── new.html.erb        # New warehouse form
│   │   ├── edit.html.erb       # Edit warehouse
│   │   └── _form.html.erb      # Warehouse form
│   └── project_inventories/
│       └── _form.html.erb      # Project inventory allocation form
├── devise/                      # Authentication views (customized)
│   ├── sessions/
│   │   └── new.html.erb        # Login page
│   ├── passwords/
│   │   ├── new.html.erb        # Forgot password
│   │   └── edit.html.erb       # Reset password
│   └── shared/
│       ├── _links.html.erb     # Auth links
│       └── _error_messages.html.erb # Form errors
└── pwa/
    └── manifest.json.erb       # PWA manifest
```

### Assets Organization

```
app/assets/
├── stylesheets/
│   └── application.css         # Main stylesheet (imports Tailwind)
├── tailwind/
│   └── application.css         # Tailwind CSS layer definitions
└── images/                      # Static images and icons

app/javascript/
├── application.js              # Entry point
├── controllers/
│   ├── application.js          # Base Stimulus controller
│   ├── confirm_delete_controller.js
│   ├── flash_controller.js
│   ├── sidebar_controller.js
│   └── project_files_controller.js
└── index.js                     # Stimulus boot
```

---

## Styling & Design

### Tailwind CSS Configuration

The application uses a custom Hamzis Systems color palette with Tailwind CSS:

```javascript
// config/tailwind.config.js
colors: {
  hamzis: {
    brown: "#4e342e",      // Primary brown
    black: "#212121",      // Deep black
    white: "#ffffff",      // White
    copper: "#b87333",     // Copper accent
    textLight: "#1f2937",  // Light mode text
    textDark: "#f3f4f6",   // Dark mode text
  }
}
```

### Color Usage

- **Background:** `bg-hamzis-white` (light) / `bg-hamzis-black` (dark)
- **Primary:** `bg-hamzis-brown` for major elements
- **Accent:** `bg-hamzis-copper` for CTAs and highlights
- **Text:** Dynamic with `dark:` variant for theme switching
- **Borders/Overlays:** `border-hamzis-brown/20` for subtle divisions

### Common Classes

```erb
<!-- Cards/Containers -->
<div class="bg-hamzis-white/30 dark:bg-hamzis-black/30 backdrop-blur-md
            border border-hamzis-brown/20 rounded-xl shadow-lg p-6">

<!-- Buttons -->
<button class="px-4 py-2 rounded bg-hamzis-copper text-hamzis-white
               hover:bg-hamzis-black transition-colors">

<!-- Gradients -->
<div class="bg-gradient-to-r from-hamzis-copper to-hamzis-brown">

<!-- Dark Mode Support -->
<div class="text-hamzis-brown dark:text-hamzis-copper
            bg-hamzis-white dark:bg-hamzis-black">
```

### Glass-morphism & Transparency

The design extensively uses CSS backdrop filters for a modern glass-morphic effect:

```css
backdrop-blur-md      /* Blur behind element */
bg-hamzis-white/30    /* 30% opacity white with blur */
dark:bg-hamzis-black/40  /* 40% opacity dark background */
```

### Responsive Design

Breakpoints used throughout:

- `sm:` - Small (640px)
- `md:` - Medium (768px)
- `lg:` - Large (1024px)
- `xl:` - Extra large (1280px)

Example:

```erb
<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
```

---

## Layout & Components

### Main Application Layout

The main layout (`layouts/application.html.erb`) consists of:

1. **Sidebar Navigation** - Collapsible left sidebar with module-specific nav
2. **Main Content** - Flex-based center column with padding
3. **Footer** - Fixed bottom with copyright and theme toggle

```erb
<body class="flex">
  <%= render 'shared/sidebar' if user_signed_in? %>
  <div class="flex-1 flex flex-col">
    <main class="px-6 py-6 flex-1">
      <%= render "shared/flash" %>
      <%= yield %>
    </main>
    <%= render 'shared/footer' %>
  </div>
</body>
```

### Sidebar Navigation

**File:** `shared/_sidebar.html.erb`

The sidebar features:

- Hamzis Systems logo with toggle
- Collapsible navigation using Stimulus
- Module-specific nav sections (Operations, Accounting, HR, Inventory)
- Active page highlighting
- Responsive hide on mobile

**Features:**

- Dynamic active state: `bg-gradient-to-r from-hamzis-copper to-hamzis-brown`
- Icon-based navigation for compact display
- Module sections render conditionally based on user role/permissions

**Module Sub-Navigation:**

- `shared/sidebar/_operations.html.erb` - Projects, Tasks, Reports
- `shared/sidebar/_accounting.html.erb` - Transactions, Salaries, Deductions
- `shared/sidebar/_hr.html.erb` - Employees, Leaves, Personal Details
- `shared/sidebar/_inventory.html.erb` - Items, Warehouses, Stock Movements

### Reusable Components

#### Flash Messages

**File:** `shared/_flash.html.erb`

Displays alert/notice messages with auto-dismiss via Stimulus controller:

```erb
<div class="alert" data-controller="flash">
  <% if notice %>
    <div class="bg-green-100 text-green-800 p-4 rounded">
      <%= notice %>
    </div>
  <% end %>
</div>
```

#### Confirm Delete Modal

**File:** `shared/_confirm_delete_modal.html.erb`

Reusable modal for delete confirmations. Triggered by Stimulus controller.

#### Tables & Lists

Common table structure for listing resources:

```erb
<div class="overflow-x-auto bg-hamzis-white/30 dark:bg-hamzis-black/30
            border border-hamzis-brown/20 rounded-xl shadow-lg p-6">
  <table class="min-w-full text-sm">
    <%= render "header_partial" %>
    <tbody class="divide-y divide-hamzis-brown/20">
      <% items.each_with_index do |item, index| %>
        <%= render "item_row", item: item,
            row_class: index.even? ? "bg-hamzis-brown/5" : "" %>
      <% end %>
    </tbody>
  </table>
</div>
```

#### KPI Cards

Summary cards displayed on dashboard and list pages:

```erb
<div class="bg-hamzis-white/30 dark:bg-hamzis-black/30 p-4 rounded-xl text-center">
  <p class="text-sm font-medium text-hamzis-brown dark:text-hamzis-copper">
    <%= label %>
  </p>
  <p class="text-xl font-bold"><%= count %></p>
</div>
```

#### Forms

Form partials follow a consistent pattern:

```erb
<%= form_with(model: resource, local: true) do |form| %>
  <%= render "shared/error_messages", object: form.object %>

  <div class="space-y-6">
    <!-- Form fields -->
    <div class="form-group">
      <%= form.label :field_name %>
      <%= form.text_field :field_name,
          class: "w-full px-3 py-2 border border-hamzis-brown/20
                   rounded-lg dark:bg-hamzis-black/30" %>
    </div>

    <!-- Submit button -->
    <div class="flex gap-3">
      <%= form.submit "Save",
          class: "px-4 py-2 rounded bg-hamzis-copper text-hamzis-white" %>
      <%= link_to "Cancel", resource, class: "px-4 py-2" %>
    </div>
  </div>
<% end %>
```

---

## JavaScript Controllers

### Stimulus Controllers Overview

Stimulus is a lightweight framework for adding JavaScript behavior to HTML. Controllers are located in `app/javascript/controllers/`.

### Core Controllers

#### 1. Application Controller

**File:** `app/javascript/controllers/application.js`

Base controller extended by all others:

```javascript
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {};
  static targets = [];
}
```

#### 2. Sidebar Controller

**File:** `app/javascript/controllers/sidebar_controller.js`

Handles sidebar collapse/expand functionality:

```javascript
export default class extends ApplicationController {
  toggle() {
    // Toggle sidebar visibility
    // Update label visibility on collapse
    // Animate transition
  }
}
```

**Usage:**

```erb
<aside data-controller="sidebar">
  <button data-action="sidebar#toggle">Toggle</button>
  <span data-sidebar-target="label">Menu Label</span>
</aside>
```

#### 3. Confirm Delete Controller

**File:** `app/javascript/controllers/confirm_delete_controller.js`

Intercepts delete links and shows confirmation modal:

```javascript
export default class extends ApplicationController {
  static targets = ["modal"];

  confirm(e) {
    e.preventDefault();
    // Show modal with event details
    // Proceed to deletion on confirmation
  }
}
```

**Usage:**

```erb
<%= link_to "Delete", resource, method: :delete,
    data: { action: "confirm-delete#confirm" } %>
```

#### 4. Flash Controller

**File:** `app/javascript/controllers/flash_controller.js`

Auto-dismisses flash messages after a timeout:

```javascript
export default class extends ApplicationController {
  connect() {
    setTimeout(() => {
      this.element.remove();
    }, 4000);
  }
}
```

#### 5. Project Files Controller

**File:** `app/javascript/controllers/project_files_controller.js`

Handles dynamic file attachment form fields:

```javascript
export default class extends ApplicationController {
  addFile() {
    // Add new file input field
  }

  removeFile(e) {
    // Mark file for deletion
  }
}
```

### Creating New Controllers

```bash
rails generate stimulus sidebar
```

This creates `app/javascript/controllers/sidebar_controller.js`:

```javascript
import { Controller } from "@hotwired/stimulus";

export default class extends ApplicationController {
  static values = {
    // Reactive values that update DOM
  };

  static targets = [
    // Elements to reference in JS
  ];

  // Lifecycle hooks
  connect() {
    // Called when controller connects
  }

  // Methods triggered by data-action
  methodName() {
    // Implementation
  }
}
```

### Connecting Controllers to HTML

```erb
<!-- Define controller -->
<div data-controller="sidebar">
  <!-- Define action (element:event -> controller#method) -->
  <button data-action="click->sidebar#toggle">Toggle</button>

  <!-- Define targets for JS reference -->
  <span data-sidebar-target="label">Label</span>

  <!-- Define values for reactive data -->
  <div data-sidebar-value-isOpen="true"></div>
</div>
```

---

## Forms & Interactivity

### Form Partials Pattern

Forms are structured as reusable partials with consistent styling:

```erb
<%= form_with(model: @project, local: true) do |form| %>
  <% if @project.errors.any? %>
    <div class="bg-red-50 border border-red-200 rounded p-4 mb-6">
      <h2 class="font-bold text-red-800"><%= @project.errors.count %> errors</h2>
      <ul class="mt-2 text-sm text-red-700">
        <% @project.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="space-y-6">
    <div>
      <%= form.label :name %>
      <%= form.text_field :name, required: true,
          class: "w-full px-3 py-2 border border-hamzis-brown/20
                   rounded-lg dark:bg-hamzis-black/30 focus:outline-none
                   focus:border-hamzis-copper" %>
    </div>

    <div>
      <%= form.label :description %>
      <%= form.text_area :description, rows: 4, required: true,
          class: "w-full px-3 py-2 border border-hamzis-brown/20
                   rounded-lg dark:bg-hamzis-black/30" %>
    </div>

    <div class="flex gap-3">
      <%= form.submit "Save Project",
          class: "px-4 py-2 bg-hamzis-copper text-hamzis-white rounded
                   hover:bg-hamzis-black transition" %>
      <%= link_to "Cancel", projects_path,
          class: "px-4 py-2 border border-hamzis-brown/20 rounded
                   hover:bg-hamzis-brown/5" %>
    </div>
  </div>
<% end %>
```

### Turbo Streams

Turbo Streams provide real-time updates without full page reloads.

**Example: Submit Report with Turbo Stream**

`reports/submit.turbo_stream.erb`:

```erb
<%= turbo_stream.update "report-<%= @report.id %>", render(
  @report, status_badge: "submitted"
) %>
<%= turbo_stream.replace "flash", render("shared/flash") %>
```

Usage in controller:

```ruby
def submit
  @report = Report.find(params[:id])
  authorize @report
  @report.update(status: :submitted)

  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to @report, notice: "Report submitted" }
  end
end
```

### Nested Forms

For complex forms with associations (e.g., Project with Files):

```erb
<%= form_with(model: @project, local: true) do |form| %>
  <!-- Project fields -->
  <div>
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <!-- Nested attributes for files -->
  <div data-controller="project-files">
    <h3>Attachments</h3>

    <%= form.fields_for :project_files do |files_form| %>
      <div class="file-field">
        <%= files_form.file_field :file %>
        <%= files_form.hidden_field :_destroy %>
        <%= button_tag "Remove", type: "button",
            data: { action: "project-files#removeFile" } %>
      </div>
    <% end %>

    <%= button_tag "Add File", type: "button",
        data: { action: "project-files#addFile" } %>
  </div>

  <%= form.submit "Save" %>
<% end %>
```

---

## Best Practices

### 1. DRY Principle - Use Partials

Break complex views into reusable partials:

```erb
<!-- Instead of duplication, render partials -->
<%= render "shared/table_header", columns: ["Name", "Status"] %>
<%= render "items/item_row", item: @item %>
```

### 2. Naming Conventions

- **Partials:** `_name.html.erb`
- **Controllers:** `name_controller.js`
- **Modules/Namespaces:** Organize in subdirectories

### 3. Accessibility

- Use semantic HTML: `<button>`, `<nav>`, `<main>`, `<aside>`
- Include `aria-label` for icon buttons
- Ensure keyboard navigation (tab order)
- Use form labels correctly

```erb
<!-- Good -->
<button aria-label="Toggle sidebar" data-action="sidebar#toggle">
  <svg><!-- icon --></svg>
</button>

<!-- Avoid -->
<div onclick="toggle()">Menu</div>
```

### 4. Responsive Images

```erb
<img src="<%= image_path 'logo.svg' %>"
     alt="Hamzis Systems logo"
     class="w-7 h-7 text-hamzis-copper">
```

### 5. Styling Guidelines

- Use utility classes over custom CSS
- Leverage Tailwind's responsive modifiers (`sm:`, `md:`, `lg:`)
- Apply dark mode with `dark:` prefix
- Use semantic color names (hamzis-brown, hamzis-copper)

```erb
<!-- Good -->
<div class="text-hamzis-brown dark:text-hamzis-copper md:text-lg">

<!-- Avoid -->
<div style="color: #4e342e; font-size: 16px;">
```

### 6. Form Validation

Display validation errors inline:

```erb
<div class="mb-4">
  <%= form.label :email %>
  <%= form.email_field :email, class: "w-full px-3 py-2 rounded
      border #{@user.errors.include?(:email) ? 'border-red-500' : 'border-hamzis-brown/20'}" %>
  <% if @user.errors.include?(:email) %>
    <p class="text-red-600 text-sm mt-1">
      <%= @user.errors.full_message_for(:email).first %>
    </p>
  <% end %>
</div>
```

### 7. Data Attributes for Testing

Use `data-testid` for testing selectors:

```erb
<button data-testid="submit-button" data-action="form#submit">
  Submit
</button>
```

### 8. Performance Optimization

- **Lazy Load Images:** Use `loading="lazy"` attribute
- **Minimize CSS:** Tailwind only includes used classes in production
- **Cache Headers:** Static assets have far-future cache headers
- **Turbo Streams:** Use for real-time updates without full reloads

### 9. Error Handling

Display user-friendly error messages:

```erb
<% if object.errors.any? %>
  <div class="bg-red-50 border border-red-300 rounded p-4">
    <h3 class="font-bold text-red-900">
      <%= pluralize(object.errors.count, "error") %> prevented saving:
    </h3>
    <ul class="mt-3 text-sm text-red-700">
      <% object.errors.full_messages.each do |message| %>
        <li>• <%= message %></li>
      <% end %>
    </ul>
  </div>
<% end %>
```

### 10. Theme Toggle Implementation

The application includes a theme toggle in the footer. Implementation uses localStorage to persist user preference:

```javascript
const root = document.documentElement;
const storageKey = "hamzis-theme";

function applyTheme(dark) {
  root.classList.toggle("dark", dark);
  localStorage.setItem(storageKey, dark ? "dark" : "light");
}

// On page load
const saved = localStorage.getItem(storageKey);
const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
const initialDark = saved === "dark" || (!saved && prefersDark);
applyTheme(initialDark);
```

---

## CSS Classes Reference

### Layout & Spacing

```
px-*, py-*, p-*         - Padding
mx-*, my-*, m-*         - Margin
w-*, h-*                - Width, Height
gap-*, space-*          - Spacing between items
flex, flex-col          - Flexbox layouts
grid, grid-cols-*       - Grid layouts
```

### Colors

```
text-hamzis-brown       - Brown text
text-hamzis-copper      - Copper text
bg-hamzis-white         - White background
bg-hamzis-black         - Black background
dark:text-hamzis-copper - Copper text in dark mode
border-hamzis-brown/20  - Brown border at 20% opacity
```

### Responsive

```
sm:, md:, lg:, xl:       - Breakpoint prefixes
```

### Effects

```
rounded-lg              - Border radius
shadow-lg               - Drop shadow
backdrop-blur-md        - Blur background
transition-colors       - Smooth color transitions
hover:, focus:          - State modifiers
```

---

## Troubleshooting

### Theme Not Switching

- Check if `dark` class is being applied to `<html>` root
- Verify localStorage is not disabled
- Clear browser cache and try again

### Styles Not Applying

- Ensure class names are in `content:` paths in `tailwind.config.js`
- Check for typos in Hamzis color names (`hamzis-brown`, not `brown`)
- Rebuild Tailwind: `./bin/dev`

### JavaScript Not Working

- Verify Stimulus controller is properly registered
- Check `data-controller` and `data-action` attributes match controller name
- Open browser console for JavaScript errors
- Ensure controller methods exist and are public

### Form Validation Issues

- Check model validations match form fields
- Verify error messages are displayed using `object.errors`
- Ensure form is using `form_with` with correct model binding

---

## Resources

- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Hotwire Documentation](https://hotwired.dev/)
- [Stimulus Handbook](https://stimulus.hotwired.dev/)
- [Rails View Templates](https://guides.rubyonrails.org/layouts_and_rendering.html)
- [ERB Documentation](https://ruby-doc.org/stdlib/libdoc/erb/rdoc/ERB.html)

- **[Project Reporting System Guide](./project_reporting_guide.md)**: Details the UI and workflow for creating and reviewing project reports.
