# 1. Fetch Users first
admin_user        = User.find_by!(email: "admin@example.com")
ceo_user          = User.find_by!(email: "ceo@example.com")
site_manager_user = User.find_by!(email: "site_manager@example.com")
engineer_user     = User.find_by!(email: "engineer@example.com")
qs_user           = User.find_by!(email: "qs@example.com")

# 2. Grab their associated Employees (Crucial for Assignments/Reports)
site_manager = site_manager_user.employee
engineer     = engineer_user.employee
qs           = qs_user.employee

# Pick seeded clients
client1 = Business::Client.find_by!(email: "client1@example.com")
client2 = Business::Client.find_by!(email: "client2@example.com")

# --- Projects ---
# Note: Projects still belong to a User (the owner/manager)
project1 = Project.create!(
  name: "Headquarters Construction",
  description: "Build the new company headquarters.",
  user: ceo_user,
  client: client1,
  status: :ongoing,
  deadline: Date.new(2026, 6, 30),
  budget: 1_000_000,
  location: "Abuja",
  address: "Central Business District"
)

project2 = Project.create!(
  name: "Warehouse Expansion",
  description: "Expand the company warehouse facilities.",
  user: admin_user,
  client: client2,
  status: :ongoing,
  deadline: Date.new(2026, 4, 30),
  budget: 500_000,
  location: "Lagos",
  address: "Industrial Layout"
)

# --- Tasks ---
task1 = Task.create!(title: "Foundation Work", details: "Lay foundation for HQ.", status: :pending, due_date: Date.new(2026, 2, 15), project: project1, weight: 5)
task2 = Task.create!(title: "Structural Framing", details: "Erect steel frames for HQ.", status: :in_progress, due_date: Date.new(2026, 3, 15), project: project1, weight: 8)
task3 = Task.create!(title: "Roof Installation", details: "Roofing for warehouse expansion.", status: :pending, due_date: Date.new(2026, 3, 20), project: project2, weight: 6)
task4 = Task.create!(title: "Electrical Wiring", details: "Complete electrical for HQ.", status: :pending, due_date: Date.new(2026, 4, 10), project: project1, weight: 4)

# --- Assignments (Swapped 'user' for 'employee') ---
Assignment.create!(task: task1, employee: site_manager)
Assignment.create!(task: task2, employee: engineer)
Assignment.create!(task: task3, employee: qs)
Assignment.create!(task: task4, employee: engineer)

# --- Reports (Swapped 'user' for 'employee') ---
Report.create!(project: project1, employee: site_manager, report_date: Date.new(2026, 1, 5), report_type: :daily, status: :submitted, progress_summary: "Foundation excavation started.", issues: "Minor delay.", next_steps: "Pour concrete.")
Report.create!(project: project1, employee: engineer, report_date: Date.new(2026, 1, 10), report_type: :weekly, status: :submitted, progress_summary: "Framing halfway complete.", issues: "Steel shortage.", next_steps: "Procure materials.")
Report.create!(project: project2, employee: qs, report_date: Date.new(2026, 1, 15), report_type: :weekly, status: :submitted, progress_summary: "Roof installation started.", issues: "None.", next_steps: "Complete by month end.")

puts "Successfully seeded projects, tasks, assignments, and reports for Earmark ERP."
