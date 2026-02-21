# 1. Fetch Users first
ceo_user          = User.find_by!(email: "ceo@example.com")
admin_user        = User.find_by!(email: "admin@example.com")
site_manager_user = User.find_by!(email: "site_manager@example.com")
engineer_user     = User.find_by!(email: "engineer@example.com")
qs_user           = User.find_by!(email: "qs@example.com")

# 2. Grab their associated Employees
site_manager = site_manager_user.employee
engineer     = engineer_user.employee
qs           = qs_user.employee

# 3. Pick seeded clients
client1 = Business::Client.find_by!(email: "client1@example.com")
client2 = Business::Client.find_by!(email: "client2@example.com")

# --- Projects ---
# Project 1: The "Hero" project for the video
project1 = Project.create!(
  name: "Abuja HQ Tower Construction",
  description: "Construction of a 12-story sustainable office complex for Dangote Group.",
  user: ceo_user,
  client: client1,
  status: :ongoing,
  deadline: Date.new(2026, 12, 31),
  budget: 15_000_000,
  location: "Abuja",
  address: "Central Business District, Phase 2"
)

# Project 2: A secondary project to show list variety
project2 = Project.create!(
  name: "Lagos Warehouse Expansion",
  description: "Expansion of existing logistics facility including new cold storage units.",
  user: admin_user,
  client: client2,
  status: :ongoing,
  deadline: Date.new(2026, 8, 15),
  budget: 8_500_000,
  location: "Lagos",
  address: "Industrial Layout, Ikeja"
)

# --- Tasks ---
# Varied statuses so the "Project Progress" charts look realistic
task1 = Task.create!(title: "Site Clearance & Excavation", details: "Clear debris and dig foundation trenches.", status: :done, due_date: 1.week.ago, project: project1, weight: 5)
task2 = Task.create!(title: "Foundation Piling", details: "Drive concrete piles into the ground.", status: :in_progress, due_date: Date.new(2026, 3, 15), project: project1, weight: 15)
task3 = Task.create!(title: "Procure Structural Steel", details: "Order and verify steel rods from warehouse.", status: :pending, due_date: Date.new(2026, 4, 1), project: project1, weight: 10)

task4 = Task.create!(title: "Roofing Framework", details: "Install steel trusses for warehouse roof.", status: :in_progress, due_date: Date.new(2026, 3, 10), project: project2, weight: 8)
task5 = Task.create!(title: "Electrical Load Assessment", details: "Calculate total power requirement for cold storage.", status: :pending, due_date: Date.new(2026, 4, 20), project: project2, weight: 5)

# --- Assignments ---
Assignment.create!(task: task1, employee: site_manager)
Assignment.create!(task: task2, employee: engineer)
Assignment.create!(task: task3, employee: qs)
Assignment.create!(task: task4, employee: engineer)
Assignment.create!(task: task5, employee: qs)

# --- Reports (The "Activity Feed" for the video) ---
# Daily report from the Site Manager
Report.create!(
  project: project1,
  employee: site_manager,
  report_date: Date.today,
  report_type: :daily,
  status: :submitted,
  progress_summary: "Excavation 100% complete. Piling equipment moved to site sector B.",
  issues: "Heavy rain delayed morning start by 2 hours.",
  next_steps: "Begin piling on the North wing tomorrow."
)

# Weekly status report from the Engineer
Report.create!(
  project: project1,
  employee: engineer,
  report_date: Date.today.beginning_of_week,
  report_type: :weekly,
  status: :submitted,
  progress_summary: "Structural review of piling plan complete. Ready for inspection.",
  issues: "None.",
  next_steps: "Coordinate with QS for next material requisition."
)

# Quality/Survey Report
Report.create!(
  project: project2,
  employee: qs,
  report_date: 2.days.ago,
  report_type: :weekly,
  status: :submitted,
  progress_summary: "Roofing materials verified. Stock levels adjusted in Lagos Warehouse.",
  issues: "Price of steel rods fluctuated; budget adjusted slightly.",
  next_steps: "Finalize contractor payments for framing."
)

puts "Successfully seeded projects, tasks, assignments, and detailed reports."
