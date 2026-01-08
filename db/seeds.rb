# Load all modular seed files
load Rails.root.join("db/seeds/users_and_employees.rb")
load Rails.root.join("db/seeds/accounting.rb")
load Rails.root.join("db/seeds/projects_and_tasks.rb")
load Rails.root.join("db/seeds/hr_leaves.rb")
load Rails.root.join("db/seeds/salaries.rb")
puts "Database seeding completed."
