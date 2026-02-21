# Frontend Developer Guide

This guide provides technical documentation for the frontend of the Earmark Systems application. It is intended for developers working on the user interface and frontend logic.

## Table of Contents

- [Technology Stack](#technology-stack)
- [File Structure](#file-structure)
- [Styling with Tailwind CSS](#styling-with-tailwind-css)
- [Interactive JavaScript with Stimulus](#interactive-javascript-with-stimulus)
- [Dynamic Pages with Turbo](#dynamic-pages-with-turbo)
- [Custom Components & Partials](#custom-components--partials)

---

## Technology Stack

The frontend is built on the standard Ruby on Rails 7+ stack, leveraging the **Hotwire** framework.

- **JavaScript Framework:** [Hotwire](https://hotwired.dev/) (Turbo + Stimulus)
- **CSS Framework:** [Tailwind CSS](https://tailwindcss.com/)
- **JS/CSS Bundling:** `esbuild` via the `jsbundling-rails` gem.
- **Asset Pipeline:** Standard Rails `sprockets`.

The philosophy is to keep logic on the server and send HTML over the wire, enhancing it with minimal, targeted JavaScript where necessary.

---

## File Structure

All frontend source files are located in the `app/` directory.

- **`app/javascript/controllers/`**: This is where all Stimulus controllers live. Each file corresponds to a `data-controller`.
- **`app/javascript/application.js`**: The main entry point for JavaScript. It initializes Stimulus and imports controllers.
- **`app/assets/stylesheets/application.tailwind.css`**: The main stylesheet where Tailwind CSS is configured and custom styles are added.
- **`app/views/`**: Contains all the ERB templates.
- **`app/views/shared/`**: Contains reusable partials and view components.

---

## Styling with Tailwind CSS

Styling is handled exclusively by Tailwind CSS.

### Configuration

The Tailwind configuration is located at `config/tailwind.config.js`. Use this file to:
- Extend the color palette.
- Add custom fonts.
- Customize spacing, breakpoints, etc.
- Register plugins.

### Workflow

1.  **Add Classes Directly:** Apply Tailwind utility classes directly in your ERB files.
    ```html
    <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
      Click Me
    </button>
    ```

2.  **Use `@apply` for Components:** For custom, reusable components (like a specific button style), use the `@apply` directive in `application.tailwind.css`.

    ```css
    /* in app/assets/stylesheets/application.tailwind.css */
    @layer components {
      .btn-primary {
        @apply bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded;
      }
    }
    ```

    Then use it in the view:
    ```html
    <button class="btn-primary">
      Click Me
    </button>
    ```

### Watching for Changes

The `bin/dev` command automatically runs the Tailwind CLI in `--watch` mode, so any changes you make to your view files will trigger a recompilation of the CSS.

---

## Interactive JavaScript with Stimulus

Stimulus is used for small, targeted pieces of interactivity.

### Creating a Controller

1.  Create a new file in `app/javascript/controllers/`, e.g., `hello_controller.js`.
2.  Write the controller code:

    ```javascript
    // app/javascript/controllers/hello_controller.js
    import { Controller } from "@hotwired/stimulus"

    export default class extends Controller {
      connect() {
        console.log("Hello, Stimulus!")
      }
    }
    ```
3.  The filename `hello_controller.js` maps to the identifier `hello`.

### Using a Controller in the View

Attach the controller to an HTML element using `data-controller`:

```html
<div data-controller="hello">
  <!-- The controller is now active on this element -->
</div>
```

### Common Patterns

-   **Toggling Classes:** Use `targets` and `classes` to add/remove CSS classes (e.g., for a dropdown menu).
-   **Making Fetch Requests:** Use the `fetch` API to get data from the server without a full page reload.
-   **Wrapping Libraries:** Wrap third-party JavaScript libraries (like chart builders or date pickers) in a Stimulus controller to manage their lifecycle.

---

## Dynamic Pages with Turbo

[Turbo](https://turbo.hotwired.dev/) makes the application feel fast and responsive by avoiding full page reloads.

### Turbo Drive

Enabled by default, Turbo Drive intercepts all link clicks and form submissions, fetches the new page in the background, and replaces the `<body>` content. You get the speed of a single-page application (SPA) with zero custom JavaScript.

### Turbo Frames

Use `turbo_frame_tag` to break a page into independent segments that can be updated individually.

**Example: An editable comment**

```erb
<%# in show.html.erb %>
<%= turbo_frame_tag dom_id(comment) do %>
  <p><%= comment.content %></p>
  <%= link_to "Edit", edit_comment_path(comment) %>
<% end %>
```

When the "Edit" link is clicked, the response from `edit_comment_path` should contain a matching `turbo_frame_tag` with the same ID. Turbo will automatically replace the content of the frame with the content from the response.

### Turbo Streams

Use Turbo Streams to modify multiple parts of the page from a single server response. This is perfect for actions like creating, updating, or deleting items in a list.

**Example: Creating a new task**

1.  The `_task.html.erb` partial wraps a task in a `dom_id`.
2.  The `create.turbo_stream.erb` view specifies how the page should change:

    ```erb
    <%# in app/views/tasks/create.turbo_stream.erb %>
    <%= turbo_stream.prepend "tasks_list", partial: "tasks/task", locals: { task: @task } %>
    ```

    This will prepend the new task to the element with the ID `tasks_list`.

You can use the following stream actions: `append`, `prepend`, `replace`, `update`, `remove`.

---

## Custom Components & Partials

To keep views clean and maintainable, the project makes extensive use of shared partials.

-   **Location:** `app/views/shared/`
-   **Usage:**
    -   Reusable UI elements (buttons, modals, form inputs).
    -   Complex, repeated layouts.

When creating a new piece of UI that you expect to reuse, always consider creating a partial for it in the `shared` directory.
