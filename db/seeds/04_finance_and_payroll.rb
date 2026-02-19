# --- Salary Batches ---
# 1. Historical Paid Batch (Last Month)
Accounting::SalaryBatch.create!(
  name: "January 2026 Payroll",
  period_start: Date.new(2026, 1, 1),
  period_end: Date.new(2026, 1, 31),
  status: :paid
)

# 2. Current Pending Batch (The one you'll "Process" in the video)
batch_feb = Accounting::SalaryBatch.create!(
  name: "February 2026 Payroll",
  period_start: Date.new(2026, 2, 1),
  period_end: Date.new(2026, 2, 28),
  status: :pending
)

# --- Salaries (Core Staff + Junior Staff) ---
Hr::Employee.all.each do |employee|
  # Determine base pay based on role/title
  base =
    case employee.position_title
    when "Chief Executive Officer" then 1_200_000
    when "Civil Engineer", "Quantity Surveyor" then 450_000
    when "Site Manager" then 400_000
    when "General Laborer", "Site Cleaner" then 85_000
    else 150_000
    end
  salary = Accounting::Salary.create!(
    batch: batch_feb,
    employee: employee,
    base_pay: base,
    allowances: (base * 0.12).to_i, # 12% allowances
    status: :pending
  )

  # Deductions
  Accounting::Deduction.create!(salary: salary, deduction_type: :tax, amount: (base * 0.05).to_i, notes: "PAYE")
  Accounting::Deduction.create!(salary: salary, deduction_type: :pension, amount: (base * 0.03).to_i, notes: "Pension")
end

# --- Transactions (Dashboard KPI Drivers) ---

# 1. Revenue: Already Received (Shows up in Cash Flow)
Accounting::Transaction.create!(
  date: 2.weeks.ago,
  description: "Initial Mobilization - Abuja HQ Tower",
  amount: 5_000_000,
  transaction_type: :receipt,
  status: :paid,
  reference: "REC-2026-001"
)

# 2. Revenue: Unpaid Invoice (This drives the "Pending Revenue" KPI on Dashboard)
Accounting::Transaction.create!(
  date: 5.days.ago,
  description: "Milestone 1 Completion - Lagos Warehouse",
  amount: 2_750_000,
  transaction_type: :invoice,
  status: :unpaid,
  reference: "INV-2026-042"
)

# 3. Expense: Overdue Utility/Vendor
Accounting::Transaction.create!(
  date: 1.week.ago,
  description: "Monthly Site Power - Abuja Depot (AEDC)",
  amount: 150_000,
  transaction_type: :invoice,
  status: :unpaid,
  reference: "UTIL-ABJ-992"
)

# --- Project Specific Expenses ---
hq_project = Project.find_by!(name: "Abuja HQ Tower Construction")
lagos_project = Project.find_by!(name: "Lagos Warehouse Expansion")

ProjectExpense.create!(
  project: hq_project,
  date: Date.today,
  description: "Soil Testing & Environmental Impact Fee",
  amount: 320_000,
  notes: "Required for Phase 2 approval"
)

ProjectExpense.create!(
  project: lagos_project,
  date: 2.days.ago,
  description: "Diesel for On-site Generator (500L)",
  amount: 600_000,
  notes: "Lagos site operational costs"
)

puts "Seeded Finance: Jan (Paid) & Feb (Pending) Payroll, ₦2.75M Pending Revenue, and Site Expenses."
