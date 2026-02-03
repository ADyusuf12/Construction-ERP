# Pick seeded users
admin        = User.find_by!(email: "admin@example.com")
ceo          = User.find_by!(email: "ceo@example.com")
site_manager = User.find_by!(email: "site_manager@example.com")
engineer     = User.find_by!(email: "engineer@example.com")
qs           = User.find_by!(email: "qs@example.com")

# Pick seeded clients
client1 = Business::Client.find_by!(email: "client1@example.com")
client2 = Business::Client.find_by!(email: "client2@example.com")

# --- Projects ---
project1 = Project.create!(
  name: "Headquarters Construction",
  description: "Build the new company headquarters.",
  user: ceo,
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
  user: admin,
  client: client2,
  status: :ongoing,
  deadline: Date.new(2026, 4, 30),
  budget: 500_000,
  location: "Lagos",
  address: "Industrial Layout"
)

# --- Tasks ---
task1 = Task.create!(title: "Foundation Work", details: "Lay the foundation for HQ building.", status: :pending, due_date: Date.new(2026, 2, 15), project: project1, weight: 5)
task2 = Task.create!(title: "Structural Framing", details: "Erect steel and concrete frames for HQ.", status: :in_progress, due_date: Date.new(2026, 3, 15), project: project1, weight: 8)
task3 = Task.create!(title: "Roof Installation", details: "Install roofing for warehouse expansion.", status: :pending, due_date: Date.new(2026, 3, 20), project: project2, weight: 6)
task4 = Task.create!(title: "Electrical Wiring", details: "Complete electrical wiring for HQ building.", status: :pending, due_date: Date.new(2026, 4, 10), project: project1, weight: 4)

# --- Assignments ---
Assignment.create!(task: task1, user: site_manager)
Assignment.create!(task: task2, user: engineer)
Assignment.create!(task: task3, user: qs)
Assignment.create!(task: task4, user: engineer)

# --- Reports ---
Report.create!(project: project1, user: site_manager, report_date: Date.new(2026, 1, 5), report_type: :daily, status: :submitted, progress_summary: "Foundation excavation started.", issues: "Minor delay due to weather.", next_steps: "Pour concrete next week.")
Report.create!(project: project1, user: engineer, report_date: Date.new(2026, 1, 10), report_type: :weekly, status: :submitted, progress_summary: "Framing work is halfway complete.", issues: "Shortage of steel rods.", next_steps: "Procure additional materials.")
Report.create!(project: project2, user: qs, report_date: Date.new(2026, 1, 15), report_type: :weekly, status: :submitted, progress_summary: "Roof installation started.", issues: "No issues reported.", next_steps: "Complete roofing by end of month.")
