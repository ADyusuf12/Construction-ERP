# HR Module Guide

This guide provides comprehensive documentation for the Human Resources (HR) module, which manages employees, organizational structure, and personal information for the Earmark Systems application.

## Table of Contents

- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Data Models](#data-models)
- [Features & Workflows](#features--workflows)
- [User Roles & Permissions](#user-roles--permissions)
- [API Endpoints](#api-endpoints)
- [Best Practices](#best-practices)

---

## Overview

The HR module manages all human resources operations within the organization, including:

- **Employee Management:** Create and maintain employee records
- **Organizational Structure:** Define manager-subordinate relationships
- **Personal Information:** Store comprehensive employee details
- **Bank Details:** Manage banking information for payroll
- **Salary Integration:** Link employees to accounting salary records
- **Employment Status:** Track active, on-leave, and terminated employees

### Core Responsibilities

1. **Employees:** Central employee record management
2. **Hierarchy:** Support for organizational structure with reporting lines
3. **Personal Details:** Comprehensive personal and banking information
4. **Status Tracking:** Monitor employment status changes

---

## Key Concepts

### Employee

An **Employee** is a person employed by the organization. Each employee has:

- **Staff ID:** Unique employee identifier (required)
- **Department:** Employee's department (optional)
- **Position Title:** Job title or role (optional)
- **Hire Date:** When employed (optional)
- **Status:** `active`, `on_leave`, or `terminated`
- **Leave Balance:** Available leave days
- **Performance Score:** Performance rating (decimal)
- **Manager:** Reference to manager (optional, for hierarchy)
- **User:** Associated application user (optional, for system access)

**Status Lifecycle:**

```
active → on_leave → active
active → terminated (irreversible)
```

### Personal Details

**Personal Details** extend employee information with:

- **Name:** First and last name
- **Date of Birth:** Employee's birthdate
- **Gender:** Gender identification
- **Marital Status:** Married, single, divorced, widowed
- **Identification:** ID type and number
- **Banking:** Bank name, account number, account name
- **Contact:** Address and phone number

This information is separate from the main employee record for privacy and security.

### Organizational Hierarchy

The HR module supports a hierarchical organizational structure through the `manager_id` field:

- Each employee can have a manager
- Managers are also employees (self-referential relationship)
- Supports unlimited hierarchy depth
- Enables approval workflows and reporting lines

**Example Structure:**

```
CEO
├── CTO
│   ├── Engineer 1
│   └── Engineer 2
├── HR Manager
│   └── HR Assistant
└── Finance Manager
    └── Accountant
```

### Employment Status

Tracks the employment status of each employee:

- **Active:** Currently employed and working
- **On Leave:** Temporarily absent but still employed
- **Terminated:** No longer employed with the organization

---

## Data Models

### Employee Model

```ruby
class Hr::Employee < ApplicationRecord
  enum :status, { active: 0, on_leave: 1, terminated: 2 }

  belongs_to :user, optional: true
  belongs_to :manager, class_name: 'Hr::Employee', optional: true
  has_many :subordinates, class_name: 'Hr::Employee', foreign_key: 'manager_id'
  has_many :leaves, class_name: 'Hr::Leave', foreign_key: 'employee_id'
  has_one :personal_detail, class_name: 'Hr::PersonalDetail'
  has_many :salaries, class_name: 'Accounting::Salary'

  validates :staff_id, presence: true, uniqueness: true
  validates :status, presence: true

  def full_name
    "#{personal_detail&.first_name} #{personal_detail&.last_name}"
  end

  def manager_name
    manager&.full_name || "No Manager"
  end

  def subordinate_names
    subordinates.map(&:full_name)
  end

  def available_leave_balance
    leave_balance
  end
end
```

**Key Attributes:**

- `staff_id: string` - Unique employee ID
- `department: string` - Department assignment
- `position_title: string` - Job title
- `hire_date: date` - Employment start date
- `status: integer` - Enum (active/on_leave/terminated)
- `leave_balance: integer` - Available leave days
- `performance_score: decimal` - Performance rating
- `user_id: bigint` - Associated user account
- `manager_id: bigint` - Manager's employee ID

**Key Methods:**

- `full_name` - Get employee's full name from personal details
- `manager_name` - Get manager's name
- `subordinate_names` - List all subordinates
- `available_leave_balance` - Current leave balance

---

### PersonalDetail Model

```ruby
class Hr::PersonalDetail < ApplicationRecord
  enum :gender, { male: 0, female: 1, other: 2 }
  enum :marital_status, { single: 0, married: 1, divorced: 2, widowed: 3 }
  enum :means_of_identification, { national_id: 0, passport: 1, drivers_license: 2 }

  belongs_to :employee, class_name: 'Hr::Employee'

  validates :employee_id, presence: true
  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
```

**Key Attributes:**

- `employee_id: bigint` - Reference to employee
- `first_name: string` - First name
- `last_name: string` - Last name
- `dob: date` - Date of birth
- `gender: integer` - Enum (male/female/other)
- `bank_name: string` - Bank name
- `account_number: string` - Bank account number
- `account_name: string` - Name on bank account
- `means_of_identification: integer` - ID type enum
- `id_number: string` - ID number
- `marital_status: integer` - Enum
- `address: text` - Physical address
- `phone_number: string` - Contact number

---

### Leave Model

```ruby
class Hr::Leave < ApplicationRecord
  enum :status, { pending: 0, approved: 1, rejected: 2, cancelled: 3 }

  belongs_to :employee, class_name: 'Hr::Employee'
  belongs_to :manager, class_name: 'Hr::Employee', optional: true

  validates :employee_id, :start_date, :end_date, :reason, presence: true
  validate :end_date_after_start_date

  def duration_days
    (end_date - start_date).to_i + 1
  end

  def pending?
    status == 'pending'
  end

  def approved?
    status == 'approved'
  end
end
```

**Key Attributes:**

- `employee_id: bigint` - Employee requesting leave
- `manager_id: bigint` - Manager approving/rejecting
- `start_date: date` - Leave start date
- `end_date: date` - Leave end date
- `reason: text` - Reason for leave
- `status: integer` - Enum (pending/approved/rejected/cancelled)

**Key Methods:**

- `duration_days` - Calculate leave duration in days
- `pending?` - Check if pending approval
- `approved?` - Check if approved

---

## Features & Workflows

### Employee Management

**Creating an Employee:**

1. Navigate to `/hr/employees/new`
2. Enter employee details:
   - **Staff ID** (required, unique) - Employee number
   - **Department** (optional) - Department name
   - **Position Title** (optional) - Job title
   - **Hire Date** (optional) - Start date
   - **Status** (default: active) - Employment status
   - **Leave Balance** (default: 0) - Annual leave days
   - **Performance Score** (optional) - Rating
   - **Manager** (optional) - Select manager from list
   - **User Account** (optional) - Link to system user
3. Save employee
4. Employee record is created

**Adding Personal Details:**

1. From employee show page, click "Add Personal Details"
2. Enter personal information:
   - **First Name** (required)
   - **Last Name** (required)
   - **Date of Birth** (optional)
   - **Gender** (optional)
   - **Marital Status** (optional)
3. Enter banking information:
   - **Bank Name** (optional)
   - **Account Number** (optional)
   - **Account Name** (optional)
4. Enter identification:
   - **Identification Type** (optional)
   - **ID Number** (optional)
5. Enter contact information:
   - **Address** (optional)
   - **Phone Number** (optional)
6. Save personal details

**Viewing Employee Information:**

1. Go to `/hr/employees/:id`
2. See:
   - Basic employment information
   - Organizational position (manager and subordinates)
   - Personal details (if added)
   - Salary records
   - Leave information
3. Edit or update any information

**Updating Employee Status:**

1. From employee record, update status:
   - **Active:** Currently working
   - **On Leave:** Temporarily absent
   - **Terminated:** No longer employed
2. Change reflected immediately in system
3. Historical records maintained for auditing

---

### Organizational Hierarchy

**Setting Manager Relationships:**

1. When creating/editing employee, select manager from dropdown
2. System automatically creates hierarchical relationship
3. Reporting lines are established for:
   - Leave approval workflows
   - Performance management
   - Organizational reporting

**Viewing Organization Structure:**

1. Go to `/hr/employees`
2. See employee list with department and manager
3. Click employee to see:
   - Direct manager (if any)
   - Direct subordinates
   - Full hierarchical path

**Manager Responsibilities:**

Managers can:

- View all direct subordinates
- Approve/reject leave requests from subordinates
- Monitor team performance scores
- Update subordinate information (if permissions allow)

---

### Personal Details Management

**Updating Personal Information:**

1. From employee show page, go to "Personal Details"
2. Click "Edit Personal Details"
3. Update any information:
   - Personal data (name, DOB, gender, etc.)
   - Banking information
   - Identification details
   - Contact information
4. Save changes

**Accessing Personal Details:**

1. Employee can view their own personal details
2. HR staff can view all employee details
3. Managers can view subordinate details
4. Personal details are separate from basic employment info

**Banking Information:**

1. Used for payroll processing
2. Should be accurate and current
3. Verified before salary batch processing
4. Can be updated anytime

---

### Attendance Tracking

The system provides functionality for tracking employee attendance.

**Recording Attendance:**

1. Navigate to `/hr/attendance_records/new`.
2. Select the employee.
3. Set the `check_in` and `check_out` times.
4. Save the record.

**Viewing Attendance:**

- **All Records:** HR staff can view all attendance records at `/hr/attendance_records`.
- **My Attendance:** Logged-in users can view their own attendance history at `/hr/attendance_records/my_attendance`.
- **Employee Specific:** View attendance for a specific employee at `/hr/employees/:employee_id/attendance_records`.

---

## User Roles & Permissions

### Role-Based Access Control

**HR Role:**

- Full access to employee records
- Create, read, update, delete employees
- View all personal details
- Manage employment status
- Cannot directly manage salary (Accountant responsibility)

**Admin Role:**

- Same access as HR
- Can override or delete employee records
- System configuration access

**Manager Role (any employee with subordinates):**

- View own profile and subordinates
- Cannot create employees
- Can approve/reject subordinate leave requests
- Can view subordinate performance scores

**Employee Role (any user):**

- View own profile
- View own personal details
- Submit own leave requests
- View own salary information (if permitted)
- Cannot modify own employment records

**Storekeeper/Engineer/QS/Site Manager/CTO/CEO:**

- Limited HR access
- Can view own profile
- Can submit leave requests

---

## Routes

These are server-side rendered routes (not JSON API endpoints). They return HTML responses with Hotwire/Turbo for fast, interactive updates.

### Employees

**List Employees:**

```
GET /hr/employees
```

**Create Employee:**

```
POST /hr/employees
Parameters: staff_id, department, position_title, hire_date, status, leave_balance, performance_score, manager_id, user_id
```

**Show Employee:**

```
GET /hr/employees/:id
```

**Update Employee:**

```
PATCH /hr/employees/:id
PUT /hr/employees/:id
Parameters: department, position_title, hire_date, status, leave_balance, performance_score, manager_id
```

**Delete Employee:**

```
DELETE /hr/employees/:id
```

---

### Personal Details

**Show Personal Details:**

```
GET /hr/employees/:employee_id/personal_detail
```

**Create Personal Details:**

```
POST /hr/employees/:employee_id/personal_detail
Parameters: first_name, last_name, dob, gender, bank_name, account_number, account_name, means_of_identification, id_number, marital_status, address, phone_number
```

**Update Personal Details:**

```
PATCH /hr/employees/:employee_id/personal_detail
PUT /hr/employees/:employee_id/personal_detail
```

---

### Attendance Records

**List Attendance Records:**
```
GET /hr/attendance_records
GET /hr/employees/:employee_id/attendance_records
```

**My Attendance:**
```
GET /hr/attendance_records/my_attendance
```

**Create Attendance Record:**
```
POST /hr/attendance_records
Parameters: employee_id, check_in, check_out, status
```

**Show Attendance Record:**
```
GET /hr/attendance_records/:id
```

**Update Attendance Record:**
```
PATCH /hr/attendance_records/:id
PUT /hr/attendance_records/:id
```

**Delete Attendance Record:**
```
DELETE /hr/attendance_records/:id
```

---

### Leaves

**List Leaves:**

```
GET /hr/leaves                    # All leaves (for managers/HR)
GET /hr/leaves/my_leaves          # Current user's leaves
```

**Create Leave Request:**

```
POST /hr/leaves
Parameters: employee_id, start_date, end_date, reason
```

**Show Leave:**

```
GET /hr/leaves/:id
```

**Update Leave Request:**

```
PATCH /hr/leaves/:id
PUT /hr/leaves/:id
Parameters: start_date, end_date, reason (only if pending)
```

**Approve Leave:**

```
PATCH /hr/leaves/:id/approve
```

**Reject Leave:**

```
PATCH /hr/leaves/:id/reject
```

**Delete Leave:**

```
DELETE /hr/leaves/:id
```

---

## Best Practices

### Employee Data Management

1. **Unique IDs:** Ensure Staff IDs are unique and meaningful
2. **Current Information:** Keep personal details updated
3. **Hire Dates:** Record accurate employment start dates
4. **Status Tracking:** Update status promptly when employment changes
5. **Complete Records:** Add personal details immediately after employee creation

### Leave Management

1. **Balance Tracking:** Monitor leave balances regularly
2. **Advance Notice:** Encourage employees to request leave in advance
3. **Manager Approval:** Ensure managers review and approve timely
4. **Deduction:** Update leave balance when leave is used
5. **Carry-over:** Define policy for unused leave carry-over

### Organizational Structure

1. **Clear Hierarchy:** Ensure each employee has appropriate manager
2. **Reporting Lines:** Maintain accurate manager relationships
3. **Performance Links:** Use hierarchy for performance management
4. **Succession Planning:** Document key positions and successors
5. **Organization Chart:** Periodically review and document structure

### Data Privacy

1. **Access Control:** Only authorized personnel can view sensitive details
2. **Banking Information:** Secure banking details separately
3. **Performance Data:** Limit performance score visibility
4. **Leave History:** Maintain confidentiality of leave records
5. **Audit Trails:** Log all access to employee records

### Payroll Integration

1. **Personal Details:** Ensure banking info is current before payroll
2. **Employment Status:** Update status before salary processing
3. **Leave Deductions:** Process leave deductions in salary calculations
4. **Address Updates:** Keep addresses current for tax/legal purposes
5. **Performance Links:** Link performance data to salary adjustments

---

## Common Tasks

### Onboarding a New Employee

1. Create employee record:
   - Enter Staff ID
   - Set department and position
   - Assign manager
   - Set hire date
   - Initialize leave balance
2. Create personal details:
   - First and last name
   - Date of birth
   - Gender and marital status
3. Add identification:
   - ID type and number
4. Add banking information:
   - Bank details for payroll
5. Create user account (if system access needed):
   - Email and password
   - Assign appropriate role
6. Link user to employee record
7. Initial leave balance entry

### Processing a Leave Request

1. Employee submits leave request at `/hr/leaves/new`
2. Provides start date, end date, reason
3. Manager receives notification (if system has notifications)
4. Manager views pending leaves at `/hr/leaves`
5. Manager reviews and either:
   - **Approves:** `/hr/leaves/:id/approve`
   - **Rejects:** `/hr/leaves/:id/reject`
6. If approved:
   - Leave balance is updated
   - Employee is notified
7. If rejected:
   - Employee can resubmit with different dates

### Updating Employee Status

1. Situation: Employee going on leave
   - Set status to "On Leave"
   - Record leave dates
   - Leave balance is reduced

2. Situation: Employee returns from leave
   - Set status back to "Active"
   - Update leave balance if used

3. Situation: Employee termination
   - Set status to "Terminated"
   - Record termination date in notes
   - Mark as unavailable for future operations
   - Final salary calculation for remaining owed days

### Organizational Reporting

1. Get organization structure:
   - List all employees at `/hr/employees`
   - View manager relationships
   - Identify reporting lines

2. Review department structure:
   - Filter employees by department
   - Analyze team size
   - Review manager coverage

3. Performance tracking:
   - View performance scores
   - Identify high/low performers
   - Plan performance reviews

---

## Troubleshooting

### Missing Personal Details

- Ensure personal details were created separately
- Check if employee has personal_detail record
- Add personal details if missing via show page

### Cannot Set Manager

- Verify target employee exists and is active
- Ensure manager is not the employee themselves
- Check for circular references (A manages B, B manages A)
- Refresh list if newly created manager doesn't appear

### Leave Balance Issues

- Verify correct leave balance set on employee
- Check if leave requests were processed
- Manually update balance if discrepancies exist
- Review all approved leaves for the employee

### Employee-User Link Issues

- Ensure user email is unique
- Verify user account exists before linking
- User can only be linked to one employee
- Unlink from other employee first if needed

### Performance Score Not Displaying

- Verify performance_score field is populated
- Check if score is null (shows as empty)
- Add score via employee edit form
- Verify access permissions for viewing scores

---

## Related Documentation

- [Database Schema - HR Module](database_schema.md#hr-module-tables)
- [API Endpoints - HR](endpoints.md#hr-human-resources)
- [Architecture - HR Module](architecture.md#human-resources-hr-module)
- [Accounting Guide - Salary Integration](accounting_guide.md#salary-records)
