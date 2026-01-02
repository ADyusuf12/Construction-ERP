# Project Reporting System Guide

This document provides a guide to the Project Reporting System, a feature for creating, submitting, and reviewing project-related reports.

## Feature Overview

The Project Reporting System allows team members to create reports on the progress of their projects. These reports can be saved as drafts, submitted for review, and then marked as reviewed by a project lead or manager. This creates a clear and auditable trail of project updates.

## User Roles & Permissions

Permissions are managed by Pundit policies. The general roles are:

- **Report Creator:** Any authenticated user can typically create a report for a project they are associated with.
- **Report Reviewer:** A user with higher-level permissions (e.g., a project manager or admin) can review submitted reports.

| Action | Report Creator | Report Reviewer |
| --- | --- | --- |
| **Create Report** | Yes | Yes |
| **View Reports** | Yes | Yes |
| **Edit Own Report** (if `draft`) | Yes | Yes |
| **Submit Report** (if `draft`) | Yes | Yes |
| **Review Report** (if `submitted`) | No | Yes |
| **Delete Report** | Yes (with permissions) | Yes (with permissions) |

## Workflow

### 1. Creating a Report

- **Path:** `/projects/:project_id/reports/new` or `/reports/new`
- **Process:**
    1. A user navigates to the "New Report" form, either from a specific project's page or from the global reports page.
    2. They must select a `project`, a `report_date`, and choose a `report_type` (e.g., Daily, Weekly).
    3. The core content of the report is entered in the `progress_summary`, `issues`, and `next_steps` fields.
    4. Upon saving, the report is created with a `draft` status, meaning it is not yet visible to reviewers.

### 2. Submitting a Report for Review

- **Process:**
    1. From the report's detail page (`/projects/:project_id/reports/:id`), the creator can see the current `draft` status.
    2. If the report is ready, the user clicks the **"Submit"** button.
    3. The report's status is updated to `submitted`.
    4. Once submitted, the report's content is typically locked, and it can no longer be edited by the creator.

### 3. Reviewing a Submitted Report

- **Process:**
    1. A project manager or reviewer monitoring the reports dashboard will see the report with a `submitted` status.
    2. They can open the report to review its contents.
    3. If the report is satisfactory, the reviewer clicks the **"Review"** button.
    4. The report's status is updated to `reviewed`, completing the workflow.
    5. All status changes happen instantly on the UI via Turbo Streams.

## Data Model

- **`Report`**: The central model for this feature.
    - `project_id`: Foreign key linking to the `Project` this report is for.
    - `user_id`: Foreign key linking to the `User` who authored the report.
    - `report_date`, `report_type`: Basic details of the report.
    - `progress_summary`, `issues`, `next_steps`: The main content of the report.
    - `status`: An enum that tracks the state of the report (`draft`, `submitted`, `reviewed`).

## UI Reference

- **`index.html.erb`**: A dashboard that can be scoped to a specific project or show all reports across the system. It includes summary statistics for reports in different states.
- **`show.html.erb`**: The detail view for a single report. This is where the primary actions (Submit, Review) are displayed based on the user's permissions and the report's status.
- **`_form.html.erb`**: The form used for creating and editing reports.
- **`_report_row.html.erb`**: A reusable partial for displaying a single report in the main `index` table.
- **`submit.turbo_stream.erb` & `review.turbo_stream.erb`**: Files used to update the UI in real-time when a report is submitted or reviewed.
