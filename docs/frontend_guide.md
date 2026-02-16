# User Guide - Hamzis Systems

This guide helps you understand how to use the Hamzis Systems application. Whether you're a manager, employee, or administrator, this guide will walk you through the key features and workflows.

## Table of Contents

- [Getting Started](#getting-started)
- [Dashboard Overview](#dashboard-overview)
- [Managing Projects](#managing-projects)
- [Working with Tasks](#working-with-tasks)
- [Creating Reports](#creating-reports)
- [HR & Leave Management](#hr--leave-management)
- [Inventory & Stock](#inventory--stock)
- [Accounting & Payroll](#accounting--payroll)
- [Managing Clients](#managing-clients)
- [Common Tasks](#common-tasks)

---

## Getting Started

### Logging In

1. Navigate to the application URL
2. Enter your email and password
3. Click "Sign In"
4. You'll be redirected to the main dashboard

### Navigation Sidebar

The sidebar on the left contains all main navigation options:

- **Dashboard** - Your main overview page
- **Projects** - View and manage all projects
- **Tasks** - Track tasks across projects
- **Reports** - Submit and review project reports
- **Inventory** - Manage stock and warehouse operations
- **Accounting** - Handle transactions and payroll
- **HR** - Employee and leave management

### Dark Mode

Click the theme toggle in the footer to switch between light and dark mode. Your preference is saved for future visits.

---

## Dashboard Overview

The dashboard shows you an at-a-glance view of your work:

### What You'll See

- **Recent Projects** - Projects you're assigned to
- **Pending Tasks** - Tasks awaiting your attention
- **Recent Reports** - Latest reports submitted
- **Quick Stats** - Overview numbers for quick reference

### Using the Dashboard

1. Click on any project or task from the dashboard to go directly to its details
2. Use the sidebar to navigate to specific modules
3. The sidebar highlights your current location

---

## Managing Projects

Projects are the main work units in Hamzis Systems. Each project contains tasks, reports, expenses, and inventory allocations.

### Viewing Projects

1. Click **Projects** in the sidebar
2. You'll see a list of all projects
3. Click on any project name to view details
4. Use filters to find specific projects

### Project Details Page

The project show page displays:

- **Project Info** - Name, description, status, deadline
- **Budget** - Total budget and remaining amount
- **Progress** - Calculated from task completion
- **Tabs** - Switch between:
  - Tasks - All tasks in this project
  - Reports - Project reports
  - Expenses - Project expenses
  - Inventory - Allocated inventory

### Creating a New Project

1. Click **Projects** in sidebar
2. Click **New Project**
3. Fill in:
   - **Name** - Project title
   - **Description** - What the project is about
   - **Location** - Physical location
   - **Address** - Full address
   - **Deadline** - When it should be completed
   - **Budget** - Total budget amount
   - **Client** - Which client (if applicable)
4. Click **Create Project**

### Project Status

Projects can have two statuses:

- **Ongoing** - Project is currently active
- **Completed** - Project is finished

---

## Working with Tasks

Tasks are individual pieces of work within projects. They help track progress and assign responsibility.

### Viewing Tasks

You can view tasks in two ways:

1. **Global View** - Click **Tasks** in sidebar to see all tasks
2. **Project View** - Go to a project and click the Tasks tab

### Task Status

Tasks progress through these statuses:

- **Pending** - Task hasn't started
- **In Progress** - Someone is working on it
- **Done** - Task is completed

### Creating a New Task

1. Navigate to the project where the task belongs
2. Click **New Task** within the project
3. Fill in:
   - **Title** - Short task name
   - **Details** - Full description (optional)
   - **Due Date** - When it should be done
   - **Weight** - Importance/size (higher = more important)
   - **Assign To** - Select team members
4. Click **Create Task**

### Working with Tasks

**Starting a Task:**

1. Open the task details
2. Click **Start Task** to change status to "In Progress"

**Completing a Task:**

1. Open the task details
2. Click **Complete Task** to mark as done
3. Progress is automatically calculated for the parent project

### Task Assignments

Tasks can be assigned to multiple people:

1. When creating/editing a task, use the "Assign To" field
2. Select one or more team members
3. All assigned users can update the task status

---

## Creating Reports

Reports document project progress. They help stakeholders stay informed about what's happening.

### Report Types

- **Daily Report** - What happened today
- **Weekly Report** - Summary for the week

### Report Workflow

```
Draft → Submitted → Reviewed
```

1. **Draft** - You're working on it (saved but not visible to others)
2. **Submitted** - Ready for manager review
3. **Reviewed** - Manager has reviewed and approved

### Creating a New Report

1. Go to the project you want to report on
2. Click the **Reports** tab
3. Click **New Report**
4. Fill in:
   - **Report Date** - Date of the report
   - **Progress Summary** - What was accomplished
   - **Issues** - Any problems encountered
   - **Next Steps** - What's planned next
5. Click **Create Report**

### Submitting a Report

1. Open a draft report
2. Click **Submit for Review**
3. Your manager will be notified to review it

### Reviewing Reports (Managers)

1. Go to the submitted report
2. Review the content
3. Click **Review Report**
4. Add any comments if needed

---

## HR & Leave Management

### Employee Profile

Your profile contains your personal and employment information:

- **Employment Details** - Department, position, hire date
- **Personal Details** - Name, contact, banking info
- **Leave Balance** - Available leave days

### Requesting Leave

1. Click **HR** in the sidebar
2. Click **Leaves**
3. Click **New Leave Request**
4. Fill in:
   - **Start Date** - When your leave begins
   - **End Date** - When you return
   - **Reason** - Brief explanation
5. Click **Submit Leave Request**

### Leave Status

Leave requests go through:

- **Pending** - Waiting for manager approval
- **Approved** - Manager said yes
- **Rejected** - Manager said no
- **Cancelled** - You cancelled the request

### Checking Leave Balance

Your available leave balance is shown:

- On your employee profile page
- When creating a new leave request

### Viewing Attendance

1. Go to **HR** → **Attendance**
2. See your daily attendance records
3. Shows: Present, Absent, Late, On Leave

---

## Inventory & Stock

The inventory system tracks materials and equipment across warehouses.

### Key Concepts

**Warehouse** - A physical location where items are stored (Main Warehouse, Site Storage, etc.)

**Inventory Item** - A type of product (Cement 50kg, Steel Rod 12mm, etc.)

**Stock Level** - How much of an item is in each warehouse

**Stock Movement** - Record of items coming in or going out

**Project Allocation** - Reserving items for a specific project

### Viewing Inventory

1. Click **Inventory** in the sidebar
2. Click **Items** to see all products
3. Each item shows:
   - SKU code
   - Current stock
   - Status (In Stock / Low Stock / Out of Stock)
   - Unit cost

### Stock Status Indicators

- 🟢 **In Stock** - Plenty available (above reorder level)
- 🟡 **Low Stock** - Running low, consider reordering
- 🔴 **Out of Stock** - None available

### Recording Stock Movements

**Receiving Items (Inbound):**

1. Go to an inventory item
2. Click **New Movement**
3. Select **Inbound**
4. Enter:
   - Destination Warehouse - Where items go
   - Quantity - How many received
   - Reference - PO or supplier info
5. Save

**Issuing Items (Outbound):**

1. Go to an inventory item
2. Click **New Movement**
3. Select **Outbound**
4. Enter:
   - Source Warehouse - Where items come from
   - Quantity - How many issued
   - Project - Which project gets these items
5. Save

**Site Delivery:**

For items delivered directly to project sites (doesn't reduce warehouse stock):

1. Create movement as "Site Delivery"
2. Select the project
3. Quantity is reserved for that project

### Allocating Inventory to Projects

Reserve items for a project:

1. Go to the project page
2. Click **Inventory** tab
3. Click **Add Inventory**
4. Select:
   - Item to allocate
   - Quantity needed
   - Purpose (what it's for)
   - Task (if specific)
5. Save

The item is now reserved and unavailable for other projects.

### Cancelling Movements

Made a mistake? You can cancel movements:

1. Open the movement
2. Click **Cancel**
3. Enter reason
4. Confirm

This reverses all stock changes and deletes any linked expenses.

---

## Accounting & Payroll

### Transactions

Track income and expenses:

1. Go to **Accounting** → **Transactions**
2. View all financial records
3. Types:
   - **Invoice** - Money coming in
   - **Receipt** - Money going out

### Salary Processing

**Salary Batches** group employee payments for a period (e.g., "January 2026").

**For Employees:**
- Your salary details are in your profile
- You receive salary slips via email after payroll
- Each slip shows: Base pay, allowances, deductions, net pay

**For Accountants:**
1. Create a salary batch
2. Add employees and their pay details
3. Add deductions (tax, pension, etc.)
4. Mark batch as processed
5. Mark as paid after payment

### Deductions

Common deduction types:
- Tax - Income tax
- Pension - Retirement contribution
- Health Insurance - Medical coverage
- Loan - Repayment deductions
- Other - Miscellaneous

---

## Managing Clients

Clients represent external companies you work with.

### Adding a Client

1. Go to **Business** → **Clients**
2. Click **New Client**
3. Enter:
   - Name - Company name
   - Email - Contact email
   - Phone - Contact number
   - Address - Company address
4. Save

### Linking Clients to Projects

When creating or editing a project, select which client it's for.

---

## Common Tasks

### Task 1: Complete a Daily Report

1. Go to your project
2. Click **Reports** tab
3. Click **New Report**
4. Enter today's date
5. Write your progress summary
6. Note any issues
7. Add next steps
8. Click **Create Report**
9. Click **Submit for Review**

### Task 2: Request Time Off

1. Go to **HR** → **Leaves**
2. Click **New Leave Request**
3. Select start and end dates
4. Write reason
5. Submit
6. Wait for manager approval

### Task 3: Allocate Materials to Project

1. Go to project page
2. Click **Inventory** tab
3. Click **Add Inventory**
4. Select the item needed
5. Enter quantity
6. Add purpose/notes
7. Save

### Task 4: Record Received Stock

1. Go to **Inventory** → **Items**
2. Find the item
3. Click **New Movement**
4. Select **Inbound**
5. Choose warehouse
6. Enter quantity
7. Add reference (PO number)
8. Save

### Task 5: Mark Task Complete

1. Find the task (global or in project)
2. Open task details
3. Click **Complete Task**
4. Project progress updates automatically

---

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Search | Press `/` |
| Go to Dashboard | Press `g` then `d` |
| Go to Projects | Press `g` then `p` |

---

## Getting Help

### If You Need Help

1. **Check this guide** - Search for your task above
2. **Ask your manager** - They can show you the workflow
3. **Contact IT** - For technical issues

### Common Error Messages

| Error | What to Do |
|-------|------------|
| "Not authorized" | You don't have permission. Ask admin. |
| "Item out of stock" | Can't allocate. Check available quantity. |
| "Leave balance insufficient" | Not enough leave days. Check balance. |
| "Project deadline passed" | Deadline has passed but status is ongoing |

---

## Tips for Success

### Daily Workflow

1. **Morning:** Check dashboard for pending tasks
2. **During Work:** Update task status as you progress
3. **End of Day:** Submit daily report
4. **Regularly:** Check for feedback on submitted reports

### Best Practices

- **Keep reports detailed** - Helps track progress accurately
- **Update task status promptly** - Shows real-time progress
- **Plan ahead** - Set realistic deadlines
- **Communicate** - Use reports to share blockers early
- **Check inventory** - Before allocating materials

### Avoiding Common Mistakes

- ❌ Don't forget to submit reports
- ❌ Don't mark tasks done without actually completing them
- ❌ Don't request more leave than you have
- ❌ Don't allocate more inventory than available

---

## Quick Reference

### Where to Find Things

| What you need | Where to look |
|--------------|---------------|
| Your tasks | Dashboard → Tasks, or Projects → Specific Project |
| Project reports | Projects → Specific Project → Reports tab |
| Leave balance | HR → Your profile |
| Available materials | Inventory → Items |
| Your salary info | HR → Your profile, or Accounting → Salaries |
| Team performance | Reports → Filter by status |

### Icons Explained

| Icon | Meaning |
|------|---------|
| 🟢 | In stock / Active |
| 🟡 | Low stock / Pending |
| 🔴 | Out of stock / Issue |
| ✅ | Complete / Approved |
| ⏳ | In progress / Pending |
| 👤 | User / Person |
| 📦 | Inventory item |
| 🏢 | Project / Warehouse |

---

_This guide is for all users of Hamzis Systems. For technical documentation, see the full [Architecture Guide](architecture.md) or [API Endpoints](endpoints.md)._
