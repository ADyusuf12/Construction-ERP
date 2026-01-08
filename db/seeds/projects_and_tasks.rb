# Pick the admin and CEO to own projects
admin = User.find_by(email: "admin@example.com")
ceo   = User.find_by(email: "ceo@example.com")
site_manager = User.find_by(email: "site_manager@example.com")
engineer     = User.find_by(email: "engineer@example.com")
qs           = User.find_by(email: "qs@example.com")

# Create sample projects owned by admin and CEO
project1 = Project.create!(
  name: "Headquarters Construction",
  description: "Build the new company headquarters.",
  user: ceo,
  status: :ongoing,
  deadline: Date.new(2026, 6, 30),
  budget: 1_000_000,
  progress: 10
)

project2 = Project.create!(
  name: "Warehouse Expansion",
  description: "Expand the company warehouse facilities.",
  user: admin,
  status: :ongoing,
  deadline: Date.new(2026, 4, 30),
  budget: 500_000,
  progress: 20
)

# Create construction-related tasks for projects
task1 = Task.create!(
  title: "Foundation Work",
  details: "Lay the foundation for HQ building.",
  status: :pending,
  due_date: Date.new(2026, 2, 15),
  project: project1,
  weight: 5
)

task2 = Task.create!(
  title: "Structural Framing",
  details: "Erect steel and concrete frames for HQ.",
  status: :in_progress,
  due_date: Date.new(2026, 3, 15),
  project: project1,
  weight: 8
)

task3 = Task.create!(
  title: "Roof Installation",
  details: "Install roofing for warehouse expansion.",
  status: :pending,
  due_date: Date.new(2026, 3, 20),
  project: project2,
  weight: 6
)

task4 = Task.create!(
  title: "Electrical Wiring",
  details: "Complete electrical wiring for HQ building.",
  status: :pending,
  due_date: Date.new(2026, 4, 10),
  project: project1,
  weight: 4
)

# Assign tasks to appropriate team members
Assignment.create!(task: task1, user: site_manager)
Assignment.create!(task: task2, user: engineer)
Assignment.create!(task: task3, user: qs)
Assignment.create!(task: task4, user: engineer)

# Create reports by the users assigned to tasks
Report.create!(
  project: project1,
  user: site_manager,   # assigned to task1
  report_date: Date.new(2026, 1, 5),
  report_type: :daily,
  status: :submitted,
  progress_summary: "Foundation excavation started.",
  issues: "Minor delay due to weather.",
  next_steps: "Pour concrete next week."
)

Report.create!(
  project: project1,
  user: engineer,       # assigned to task2
  report_date: Date.new(2026, 1, 10),
  report_type: :weekly,
  status: :submitted,
  progress_summary: "Framing work is halfway complete.",
  issues: "Shortage of steel rods.",
  next_steps: "Procure additional materials."
)

Report.create!(
  project: project2,
  user: qs,             # assigned to task3
  report_date: Date.new(2026, 1, 15),
  report_type: :weekly,
  status: :submitted,
  progress_summary: "Roof trusses delivered to site.",
  issues: "Awaiting roofing sheets.",
  next_steps: "Begin installation once materials arrive."
)

Report.create!(
  project: project1,
  user: engineer,       # assigned to task4
  report_date: Date.new(2026, 1, 20),
  report_type: :daily,
  status: :submitted,
  progress_summary: "Electrical wiring started on ground floor.",
  issues: "Need additional electricians.",
  next_steps: "Hire subcontractors to speed up work."
)

# Create transactions
Accounting::Transaction.create!(
  project: project1,
  date: Date.new(2026, 1, 4),
  description: "Purchase cement",
  amount: 50_000,
  transaction_type: :receipt,
  status: :paid,
  reference: "TXN001",
  notes: "Bulk cement order"
)

Accounting::Transaction.create!(
  project: project2,
  date: Date.new(2026, 1, 6),
  description: "Purchase steel beams",
  amount: 75_000,
  transaction_type: :receipt,
  status: :paid,
  reference: "TXN002",
  notes: "Steel beams for warehouse framing"
)

puts "Seeded construction projects (CEO + Admin owners), tasks, assignments, reports by task assignees, and transactions."
