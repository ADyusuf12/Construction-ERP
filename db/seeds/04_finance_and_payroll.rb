# --- Salary Batches ---
batch_jan = Accounting::SalaryBatch.create!(
  name: "January Payroll",
  period_start: Date.new(2026, 1, 1),
  period_end: Date.new(2026, 1, 31),
  status: :pending
)

Accounting::SalaryBatch.create!(
  name: "February Payroll",
  period_start: Date.new(2026, 2, 1),
  period_end: Date.new(2026, 2, 28),
  status: :pending
)

# --- Salaries for multiple employees ---
[ "engineer@example.com", "qs@example.com", "site_manager@example.com", "hr@example.com", "accountant@example.com" ].each do |email|
  employee = Hr::Employee.joins(:user).find_by(users: { email: email })

  salary = Accounting::Salary.create!(
    batch: batch_jan,
    employee: employee,
    base_pay: rand(3000..7000),
    allowances: rand(200..1000),
    deductions_total: 0,
    status: :pending
  )

  # Add deductions
  Accounting::Deduction.create!(salary: salary, deduction_type: :tax, amount: rand(100..300), notes: "Tax deduction")
  Accounting::Deduction.create!(salary: salary, deduction_type: :pension, amount: rand(50..150), notes: "Pension contribution")

  salary.update!(status: :paid)
end

puts "Seeded January & February payroll batches with multiple employees and deductions."

# --- Transactions ---
Accounting::Transaction.create!(
  date: Date.new(2026, 1, 10),
  description: "Client payment for HQ project milestone",
  amount: 200_000,
  transaction_type: :receipt,
  status: :paid,
  reference: "INV-001"
)

Accounting::Transaction.create!(
  date: Date.new(2026, 1, 15),
  description: "Invoice for warehouse expansion materials",
  amount: 150_000,
  transaction_type: :invoice,
  status: :unpaid,
  reference: "INV-002"
)

# --- Project Expenses ---
ProjectExpense.create!(
  project: Project.find_by(name: "Headquarters Construction"),
  date: Date.new(2026, 1, 12),
  description: "Payment to subcontractor for excavation",
  amount: 50_000,
  notes: "Excavation completed on schedule"
)

ProjectExpense.create!(
  project: Project.find_by(name: "Warehouse Expansion"),
  date: Date.new(2026, 1, 18),
  description: "Purchase of roofing sheets",
  amount: 160_000,
  notes: "Materials delivered to site"
)
# --- Project Files ---

puts "Seeded transactions, project expenses, and project files."
