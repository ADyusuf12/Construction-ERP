# Load all modular seed files in dependency order
load Rails.root.join("db/seeds/users_and_employees.rb")   # must be first
load Rails.root.join("db/seeds/projects_and_tasks.rb")    # needs users + clients
load Rails.root.join("db/seeds/hr_leaves.rb")             # needs employees
load Rails.root.join("db/seeds/hr_attendance_records.rb") # needs employees + projects
load Rails.root.join("db/seeds/accounting.rb")            # needs employees
load Rails.root.join("db/seeds/salaries.rb")              # needs employees

puts "Database seeding completed."
