puts "Seeding Finance and Payroll History..."

# 1. Historical Paid Batch (Last Month)
# Creating this automatically triggers the populate_salaries_from_staff_roster hook!
jan_batch = Accounting::SalaryBatch.create!(
  name: "January 2026 Payroll",
  period_start: Date.new(2026, 1, 1),
  period_end: Date.new(2026, 1, 31),
  status: :paid
)

# Since the hook creates salaries as 'pending', we just need to flip Jan to 'paid'
jan_batch.salaries.update_all(status: :paid)

# 2. Add some historical deductions to January for realism
jan_batch.salaries.each do |salary|
  Accounting::Deduction.create!(
    salary: salary,
    deduction_type: :tax,
    amount: (salary.base_pay * 0.05).to_i,
    notes: "PAYE Tax"
  )
end

# We want the index to only show January so you can create February "Live" in the video.

# --- Transactions (Revenue/Expenses) ---
Accounting::Transaction.create!(
  date: 2.weeks.ago,
  description: "Initial Mobilization - Abuja HQ Tower",
  amount: 5_000_000,
  transaction_type: :receipt,
  status: :paid,
  reference: "REC-2026-001"
)

# 2. Revenue: Unpaid Invoice (Pending Revenue KPI)
Accounting::Transaction.create!(
  date: 5.days.ago,
  description: "Milestone 1 Completion - Lagos Warehouse",
  amount: 2_750_000,
  transaction_type: :invoice,
  status: :unpaid,
  reference: "INV-2026-042"
)

# 3. Expense: Overdue Utility
Accounting::Transaction.create!(
  date: 1.week.ago,
  description: "Monthly Site Power - Abuja Depot (AEDC)",
  amount: 150_000,
  transaction_type: :invoice,
  status: :unpaid,
  reference: "UTIL-ABJ-992"
)

# --- Project Specific Expenses ---
hq_project = Project.find_by(name: "Abuja HQ Tower Construction")
lagos_project = Project.find_by(name: "Lagos Warehouse Expansion")

if hq_project
  ProjectExpense.create!(
    project: hq_project,
    date: Date.today,
    description: "Soil Testing & Environmental Impact Fee",
    amount: 320_000,
    notes: "Required for Phase 2 approval"
  )
end

if lagos_project
  ProjectExpense.create!(
    project: lagos_project,
    date: 2.days.ago,
    description: "Diesel for On-site Generator (500L)",
    amount: 600_000,
    notes: "Lagos site operational costs"
  )
end

puts "✅ Finance Ready: January settled. Ready for February live demo."
