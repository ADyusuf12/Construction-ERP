# Find an existing employee (from your main seeds.rb)
employee = Hr::Employee.joins(:user).find_by(users: { email: "accountant@example.com" })

# Create a salary batch
batch = Accounting::SalaryBatch.create!(
  name: "January Payroll",
  period_start: Date.new(2026, 1, 1),
  period_end: Date.new(2026, 1, 31),
  status: :pending
)

# Create a salary record for the employee
salary = Accounting::Salary.create!(
  batch: batch,
  employee: employee,
  base_pay: 5000,
  allowances: 500,
  deductions_total: 200,
  status: :pending
  # net_pay will be auto-calculated by before_save
)

# Add a deduction record to test itemization
Accounting::Deduction.create!(
  salary: salary,
  deduction_type: :tax,
  amount: 150
)

Accounting::Deduction.create!(
  salary: salary,
  deduction_type: :pension,
  amount: 50
)

# Enqueue the job to test Solid Queue
SalarySlipJob.perform_later(batch.id)

puts "Created salary batch ##{batch.id}, salary with deductions, and enqueued SalarySlipJob"
