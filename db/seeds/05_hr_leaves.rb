# Fetch some employees
engineer     = Hr::Employee.joins(:user).find_by(users: { email: "engineer@example.com" })
site_manager = Hr::Employee.joins(:user).find_by(users: { email: "site_manager@example.com" })
hr_officer   = Hr::Employee.joins(:user).find_by(users: { email: "hr@example.com" })

# Pending leave request
Hr::Leave.create!(
  employee: engineer,
  manager: site_manager,
  start_date: Date.new(2026, 2, 1),
  end_date: Date.new(2026, 2, 5),
  reason: "Family event",
  status: :pending
)

# Approved leave request (with balance deduction applied)
approved_leave = Hr::Leave.create!(
  employee: site_manager,
  manager: hr_officer,
  start_date: Date.new(2026, 1, 15),
  end_date: Date.new(2026, 1, 20),
  reason: "Medical checkup",
  status: :approved
)
approved_leave.apply_leave_balance!

# Rejected leave request
Hr::Leave.create!(
  employee: hr_officer,
  manager: engineer,
  start_date: Date.new(2026, 3, 10),
  end_date: Date.new(2026, 3, 12),
  reason: "Vacation trip",
  status: :rejected
)

puts "Seeded HR leave requests (pending, approved with balance deduction, rejected)."
