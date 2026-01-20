# Find an existing employee (we’ll use the accountant for payroll testing)
accountant = Hr::Employee.joins(:user).find_by(users: { email: "accountant@example.com" })

# Create a salary batch
batch = Accounting::SalaryBatch.create!(
  name: "January Payroll",
  period_start: Date.new(2026, 1, 1),
  period_end: Date.new(2026, 1, 31),
  status: :pending
)

# Create a salary record for the accountant
salary = Accounting::Salary.create!(
  batch: batch,
  employee: accountant,
  base_pay: 5000,
  allowances: 500,
  deductions_total: 200,
  net_pay: 5300,
  status: :pending
)

# Add a deduction record
Accounting::Deduction.create!(
  salary: salary,
  deduction_type: 0, # e.g. tax
  amount: 200,
  notes: "Tax deduction"
)

puts "Seeded accounting data: batch ##{batch.id}, salary ##{salary.id}, deduction created."
