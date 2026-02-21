# Accounting Module Guide

This guide provides comprehensive documentation for the Accounting module, which handles financial transactions, salary management, and deductions for the Earmark Systems application.

## Table of Contents

- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Data Models](#data-models)
- [Features & Workflows](#features--workflows)
- [User Roles & Permissions](#user-roles--permissions)
- [Routes](#routes)
- [Best Practices](#best-practices)

---

## Overview

The Accounting module manages all financial operations within the organization, including:

- **Transaction Management:** Recording income and expenses
- **Salary Management:** Processing payroll with batches and deductions
- **Financial Reporting:** Tracking and organizing financial data
- **Deduction Management:** Managing employee deductions (taxes, pension, insurance, etc.)

### Core Responsibilities

1. **Transactions:** Record and track financial transactions (payments, receipts)
2. **Salary Batches:** Group and process salaries for payroll periods
3. **Salary Records:** Individual employee salary calculations
4. **Deductions:** Itemize and track salary deductions

---

## Key Concepts

### Transactions

A **Transaction** represents a financial movement within the organization. Each transaction has:

- **Date:** When the transaction occurred
- **Description:** What the transaction is for
- **Amount:** The monetary value
- **Type:** `payment` (outgoing) or `receipt` (incoming)
- **Status:** `pending`, `paid`, or `failed`
- **Reference:** Optional reference number for tracking
- **Notes:** Additional context or details

**Status Workflow:**

```
pending → paid (or failed)
```

### Salary Batches

A **Salary Batch** represents a period of salary processing (e.g., monthly payroll). It contains:

- **Name:** Descriptive name (e.g., "January 2026 Payroll")
- **Period Start & End:** Date range for the salary period
- **Status:** `pending`, `processed`, or `paid`
- **Salaries:** Multiple individual salary records

**Status Workflow:**

```
pending → processed → paid
```

### Salary Records

A **Salary** represents an employee's compensation for a salary batch. It includes:

- **Base Pay:** Fixed salary amount
- **Allowances:** Additional compensation (bonuses, overtime, etc.)
- **Deductions Total:** Automatically calculated sum of deductions
- **Net Pay:** `Base Pay + Allowances - Deductions Total` (auto-calculated)
- **Status:** `pending`, `processed`, or `paid`

**Calculation Formula:**

```
Net Pay = Base Pay + Allowances - Deductions Total
```

### Deductions

A **Deduction** represents an itemized deduction from an employee's salary. Types include:

- **Tax:** Income tax deductions
- **Pension:** Retirement/pension contributions
- **Insurance:** Health or other insurance deductions
- **Other:** Miscellaneous deductions

Each deduction has:

- **Type:** Category of deduction
- **Amount:** Deduction amount
- **Notes:** Optional explanation

---

## Data Models

### Transaction Model

```ruby
class Accounting::Transaction < ApplicationRecord
  enum :transaction_type, { payment: 0, receipt: 1 }
  enum :status, { pending: 0, paid: 1, failed: 2 }

  validates :date, :description, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
```

**Key Attributes:**

- `date: date` - Transaction date
- `description: string` - Transaction description
- `amount: decimal` - Transaction amount
- `transaction_type: integer` - Enum (payment/receipt)
- `status: integer` - Enum (pending/paid/failed)
- `reference: string` - Reference number
- `notes: text` - Additional notes

**Associations:**

- None (global transactions)

---

### SalaryBatch Model

```ruby
class Accounting::SalaryBatch < ApplicationRecord
  enum :status, { pending: 0, processed: 1, paid: 2 }

  has_many :salaries, dependent: :destroy

  validates :name, :period_start, :period_end, presence: true
end
```

**Key Attributes:**

- `name: string` - Batch name
- `period_start: date` - Period start date
- `period_end: date` - Period end date
- `status: integer` - Enum (pending/processed/paid)

**Associations:**

- `has_many :salaries` - Salaries in this batch

---

### Salary Model

```ruby
class Accounting::Salary < ApplicationRecord
  enum :status, { pending: 0, processed: 1, paid: 2 }

  belongs_to :employee, class_name: 'Hr::Employee'
  belongs_to :batch, class_name: 'Accounting::SalaryBatch'
  has_many :deductions, dependent: :destroy

  before_save :calculate_net_pay

  validates :base_pay, :employee_id, :batch_id, presence: true

  private

  def calculate_net_pay
    self.net_pay = base_pay + allowances - deductions_total
  end
end
```

**Key Attributes:**

- `employee_id: bigint` - Reference to employee
- `batch_id: bigint` - Reference to salary batch
- `base_pay: decimal` - Base salary amount
- `allowances: decimal` - Additional compensation
- `deductions_total: decimal` - Sum of deductions
- `net_pay: decimal` - Calculated net pay
- `status: integer` - Enum (pending/processed/paid)

**Associations:**

- `belongs_to :employee`
- `belongs_to :batch`
- `has_many :deductions`

---

### Deduction Model

```ruby
class Accounting::Deduction < ApplicationRecord
  enum :deduction_type, { tax: 0, pension: 1, insurance: 2, other: 3 }

  belongs_to :salary

  validates :deduction_type, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
```

**Key Attributes:**

- `salary_id: bigint` - Reference to salary
- `deduction_type: integer` - Enum (tax/pension/insurance/other)
- `amount: decimal` - Deduction amount
- `notes: text` - Optional notes

**Associations:**

- `belongs_to :salary`

---

## Features & Workflows

### Transaction Management Workflow

**Creating a Transaction:**

1. Navigate to `/accounting/transactions/new`
2. Fill in transaction details:
   - Date (defaults to today)
   - Description (required)
   - Amount (required, must be positive)
   - Type (payment or receipt)
   - Reference (optional)
   - Notes (optional)
3. Submit the form
4. Transaction is created in `pending` status

**Marking as Paid:**

1. View transaction at `/accounting/transactions/:id`
2. Click "Mark as Paid" button
3. Status changes to `paid`
4. Transaction is now recorded as completed

**Transaction Tracking:**

- All transactions are listed at `/accounting/transactions`
- Filter by status or date range
- View detailed information for each transaction
- Edit or delete pending transactions

---

### Salary Batch Processing Workflow

**Creating a Salary Batch:**

1. Navigate to `/accounting/salary_batches/new`
2. Enter batch details:
   - Name (e.g., "January 2026 Payroll")
   - Period start date
   - Period end date
3. Create batch (status: `pending`)

**Adding Salaries to Batch:**

1. From batch show page, click "Add Salary"
2. Select employee
3. Enter salary details:
   - Base pay (required)
   - Allowances (optional)
4. System automatically calculates deductions total and net pay

**Adding Deductions to Salary:**

1. From salary show page, click "Add Deduction"
2. Select deduction type (tax, pension, insurance, other)
3. Enter amount
4. Add notes (optional)
5. Deduction is added and salary net pay is recalculated

**Processing the Batch:**

1. From batch show page, verify all salaries
2. Click "Mark as Processed"
3. Batch status changes to `processed`
4. Salaries are ready for payment

**Marking Batch as Paid:**

1. From batch show page, click "Mark as Paid"
2. Batch status changes to `paid`
3. All salaries in batch are marked as `paid`
4. Payroll cycle is complete

---

### Individual Salary Management

**Viewing Salary Details:**

- Access via batch: `/accounting/salary_batches/:batch_id/salaries/:id`
- Or globally: `/accounting/salaries/:id`
- See complete breakdown:
  - Base pay
  - Allowances
  - Deductions (itemized)
  - Calculated net pay

**Updating a Salary:**

1. From salary show page, click "Edit"
2. Modify base pay or allowances
3. System recalculates net pay automatically
4. Save changes

**Marking Salary as Paid:**

1. From salary show page, click "Mark as Paid"
2. Individual salary status changes to `paid`
3. Can be done independently of batch status

---

## User Roles & Permissions

### Role-Based Access Control

**Accountant Role:**

- Full access to all accounting features
- Create, read, update, delete transactions
- Create and manage salary batches
- Add and manage salaries and deductions
- Mark transactions and salaries as paid
- View all payroll records

**Admin Role:**

- Same access as Accountant
- Can manage system-level settings

**HR Role:**

- Read-only access to salary information
- View employee salary history
- Cannot create or modify transactions

**Other Roles:**

- No direct access to accounting features
- May view personal salary information if applicable

---

## Routes

These are server-side rendered routes (not JSON API endpoints). They return HTML responses with Hotwire/Turbo for fast, interactive updates.

### Transactions

**List Transactions:**

```
GET /accounting/transactions
```

**Create Transaction:**

```
POST /accounting/transactions
Parameters: date, description, amount, transaction_type, reference, notes
```

**Show Transaction:**

```
GET /accounting/transactions/:id
```

**Update Transaction:**

```
PATCH /accounting/transactions/:id
PUT /accounting/transactions/:id
```

**Delete Transaction:**

```
DELETE /accounting/transactions/:id
```

**Mark as Paid:**

```
PATCH /accounting/transactions/:id/mark_paid
```

---

### Salary Batches

**List Batches:**

```
GET /accounting/salary_batches
```

**Create Batch:**

```
POST /accounting/salary_batches
Parameters: name, period_start, period_end
```

**Show Batch:**

```
GET /accounting/salary_batches/:id
```

**Mark as Paid:**

```
PATCH /accounting/salary_batches/:id/mark_paid
```

---

### Salaries

**List Salaries:**

```
GET /accounting/salaries
GET /accounting/salary_batches/:batch_id/salaries
```

**Create Salary:**

```
POST /accounting/salaries
POST /accounting/salary_batches/:batch_id/salaries
Parameters: employee_id, base_pay, allowances
```

**Show Salary:**

```
GET /accounting/salaries/:id
```

**Update Salary:**

```
PATCH /accounting/salaries/:id
PUT /accounting/salaries/:id
Parameters: base_pay, allowances
```

**Mark as Paid:**

```
PATCH /accounting/salaries/:id/mark_paid
```

---

### Deductions

**List Deductions:**

```
GET /accounting/deductions
GET /accounting/salaries/:salary_id/deductions
```

**Create Deduction:**

```
POST /accounting/deductions
POST /accounting/salaries/:salary_id/deductions
Parameters: deduction_type, amount, notes
```

**Show Deduction:**

```
GET /accounting/deductions/:id
```

**Update Deduction:**

```
PATCH /accounting/deductions/:id
PUT /accounting/deductions/:id
```

**Delete Deduction:**

```
DELETE /accounting/deductions/:id
```

---

## Best Practices

### Financial Data Integrity

1. **Always Verify Amounts:** Before marking transactions or salaries as paid, verify amounts are correct
2. **Use References:** Include reference numbers for tracking and reconciliation
3. **Document Deductions:** Always add notes explaining non-standard deductions
4. **Batch Processing:** Process salaries in batches to ensure consistency and auditability

### Workflow Guidelines

1. **Pending Status:** Keep items in pending until fully verified
2. **Batch Completeness:** Ensure all employees are added before marking batch as processed
3. **Deduction Review:** Review all deductions before finalizing salary calculations
4. **Payment Records:** Keep detailed notes for audit trails

### Security Considerations

1. **Access Control:** Only accountants and admins should have full access
2. **Audit Trail:** All changes are logged with timestamps
3. **Sensitive Data:** Never share detailed salary information outside necessary channels
4. **Reconciliation:** Regularly reconcile transactions with external financial records

### Performance Tips

1. **Batch Operations:** Process salaries in monthly batches rather than individually
2. **Filtering:** Use date ranges to filter large transaction lists
3. **Exports:** Generate reports for external accounting software if needed

---

## Common Tasks

### Monthly Payroll Processing

1. Create new salary batch for the month
2. Add all active employees to the batch
3. Enter base pay (from employment records)
4. Add any allowances (bonuses, overtime)
5. Add all applicable deductions (tax, pension)
6. Review all calculations
7. Mark batch as processed
8. Perform final verification
9. Mark batch as paid
10. Generate payroll report

### Transaction Reconciliation

1. Go to `/accounting/transactions`
2. Filter by date range
3. Verify each transaction against source documents
4. Update statuses as confirmed
5. Generate reconciliation report

### Employee Salary History

1. Navigate to employee record
2. View associated salary records
3. Review salary trends and deductions
4. Export for employee records

---

## Troubleshooting

### Net Pay Not Calculating Correctly

- Check that all deductions have been added
- Verify base pay and allowances are entered correctly
- Ensure deduction amounts are positive
- Manual recalculation: `Base Pay + Allowances - Deductions Total`

### Unable to Mark Transaction as Paid

- Verify transaction is in `pending` status
- Check user has accountant or admin role
- Ensure transaction details are complete

### Salary Discrepancies

- Review all deductions for the salary
- Check employee was not added to multiple batches
- Verify base pay and allowances against employment records

---

## Related Documentation

- [Database Schema - Accounting Module](database_schema.md#accounting-module)
- [API Endpoints - Accounting](endpoints.md#accounting)
- [Architecture - Accounting Module](architecture.md#accounting-module)
