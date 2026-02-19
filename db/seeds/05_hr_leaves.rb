# Fetch key actors
engineer_emp = Hr::Employee.joins(:user).find_by(users: { email: "engineer@example.com" })
site_manager_emp = Hr::Employee.joins(:user).find_by(users: { email: "site_manager@example.com" })
hr_officer_emp = Hr::Employee.joins(:user).find_by(users: { email: "hr@example.com" })

# 1. The "Video Hero": Pending request to be approved on camera
Hr::Leave.create!(
  employee: engineer_emp,
  manager: hr_officer_emp,
  start_date: Date.today + 10.days,
  end_date: Date.today + 15.days,
  reason: "Annual Vacation - Traveling to Enugu for family event",
  status: :pending
)

# 2. Historical Approved Leaves (Shows data in the 'History' view)
approved_leave = Hr::Leave.create!(
  employee: site_manager_emp,
  manager: hr_officer_emp,
  start_date: 1.month.ago,
  end_date: 1.month.ago + 3.days,
  reason: "Medical Checkup & Recovery",
  status: :approved
)
# Force-apply balance deduction for seeded approved leave
approved_leave.apply_leave_balance! if approved_leave.respond_to?(:apply_leave_balance!)

# 3. A Rejected Request (Shows the system handles refusals)
Hr::Leave.create!(
  employee: Hr::Employee.find_by(position_title: "General Laborer"),
  manager: site_manager_emp,
  start_date: Date.today + 1.day,
  end_date: Date.today + 2.days,
  reason: "Personal leave (Short notice)",
  status: :rejected
)

# 4. A Canceled Request
Hr::Leave.create!(
  employee: Hr::Employee.find_by(position_title: "Junior Mason"),
  manager: site_manager_emp,
  start_date: Date.today + 20.days,
  end_date: Date.today + 25.days,
  reason: "Course Attendance",
  status: :cancelled
)

puts "Seeded HR Leaves: 1 Pending (Hero), 1 Approved, 1 Rejected, 1 Cancelled."
