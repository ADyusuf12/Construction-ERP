# HR Leave Management System Guide

This document provides a guide to the HR Leave Management System, a feature designed to streamline the process of requesting and approving employee leave.

## Feature Overview

The Leave Management System allows employees to submit leave requests through a simple and intuitive interface. These requests are then routed to their designated managers for approval or rejection. The system tracks leave balances and maintains a history of all requests.

## User Roles & Permissions

The system has two primary roles:

- **Employee:** Any user with an associated `Hr::Employee` record.
- **Manager:** An `Hr::Employee` who is designated as the `manager` for other employees.

Permissions are managed by Pundit policies and are generally as follows:

| Action | Employee | Manager |
| --- | --- | --- |
| **Request Leave** | Yes | Yes |
| **View Own Leave History** (`/hr/leaves/my_leaves`) | Yes | Yes |
| **Cancel Own Request** (if pending) | Yes | Yes |
| **View Subordinates' Requests** (`/hr/leaves`) | No | Yes |
| **Approve/Reject Subordinates' Requests** | No | Yes |

## Workflow

### 1. Submitting a Leave Request

- **Path:** `/hr/leaves/new`
- **Process:**
    1. An employee navigates to the "New Leave" form.
    2. They select a `start_date`, `end_date`, and provide a `reason` for their absence.
    3. Upon submission, the system creates a `Hr::Leave` record with a `pending` status.
    4. The request is automatically associated with the employee's designated manager.

### 2. Viewing and Managing Personal Leave

- **Path:** `/hr/leaves/my_leaves`
- **Process:**
    1. An employee can view a list of all their past and present leave requests.
    2. The view includes the status of each request (Pending, Approved, Rejected, Cancelled).
    3. If a request is still `pending`, the employee has the option to **cancel** it.

### 3. Manager's Review Dashboard

- **Path:** `/hr/leaves`
- **Process:**
    1. A manager can view a comprehensive list of all leave requests submitted by their direct reports.
    2. The dashboard provides a summary of pending, approved, and rejected requests.
    3. The manager can click on any request to view its details.

### 4. Approving or Rejecting a Request

- **Process:**
    1. From the main leave dashboard or the specific request's page, a manager has two primary actions: **Approve** or **Reject**.
    2. **Approval:** If approved, the request's status is changed to `approved`, and the number of leave days is automatically deducted from the employee's `leave_balance`.
    3. **Rejection:** If rejected, the status is simply updated to `rejected`. The employee's leave balance is not affected.
    4. These actions are performed via Turbo Streams, allowing the UI to update instantly without a full page reload.

## Data Model

- **`Hr::Leave`**: The central model for this feature.
    - `employee_id`: Foreign key linking to the `Hr::Employee` who is requesting leave.
    - `manager_id`: Foreign key linking to the employee's manager.
    - `start_date`, `end_date`, `reason`: Core details of the leave request.
    - `status`: An enum that tracks the state of the request (`pending`, `approved`, `rejected`, `cancelled`).
- **`Hr::Employee`**:
    - `leave_balance`: An integer that tracks the remaining leave days for an employee.

## UI Reference

- **`my_leaves.html.erb`**: A personalized dashboard for employees to see their own requests.
- **`index.html.erb`**: The manager's dashboard, showing all subordinate requests and summary statistics.
- **`_leave_table.html.erb`**: A reusable partial that renders the list of leave requests, used on both the employee and manager pages.
- **`_form.html.erb`**: The form used for creating and editing leave requests.
- **`*.turbo_stream.erb`**: Files used to update the UI in real-time when a manager approves, rejects, or an employee cancels a request.
