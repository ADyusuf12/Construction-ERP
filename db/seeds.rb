# Helper to create a user + employee together
def create_user_and_employee(email:, role:, department:, position_title:, hire_date:, leave_balance:)
  user = User.create!(
    email: email,
    password: "password",
    role: role
  )

  Hr::Employee.create!(
    user: user,
    department: department,
    position_title: position_title,
    hire_date: hire_date,
    status: :active,
    leave_balance: leave_balance,
    performance_score: nil
  )
end

# CEO
create_user_and_employee(
  email: "ceo@example.com",
  role: :ceo,
  department: "Executive",
  position_title: "Chief Executive Officer",
  hire_date: Date.new(2020, 1, 1),
  leave_balance: 30
)

# CTO
create_user_and_employee(
  email: "cto@example.com",
  role: :cto,
  department: "Technical",
  position_title: "Chief Technical Officer",
  hire_date: Date.new(2021, 1, 1),
  leave_balance: 25
)

# QS
create_user_and_employee(
  email: "qs@example.com",
  role: :qs,
  department: "Quality",
  position_title: "Quantity Surveyor",
  hire_date: Date.new(2022, 1, 1),
  leave_balance: 20
)

# Site Manager (renamed role)
create_user_and_employee(
  email: "site_manager@example.com",
  role: :site_manager,
  department: "Operations",
  position_title: "Site Manager",
  hire_date: Date.new(2021, 6, 1),
  leave_balance: 18
)

# Engineer
create_user_and_employee(
  email: "engineer@example.com",
  role: :engineer,
  department: "Engineering",
  position_title: "Engineer",
  hire_date: Date.new(2022, 3, 1),
  leave_balance: 15
)

# Storekeeper
create_user_and_employee(
  email: "storekeeper@example.com",
  role: :storekeeper,
  department: "Inventory",
  position_title: "Storekeeper",
  hire_date: Date.new(2023, 1, 1),
  leave_balance: 12
)

# HR
create_user_and_employee(
  email: "hr@example.com",
  role: :hr,
  department: "Human Resources",
  position_title: "HR Officer",
  hire_date: Date.new(2022, 9, 1),
  leave_balance: 20
)

# Accountant
create_user_and_employee(
  email: "accountant@example.com",
  role: :accountant,
  department: "Finance",
  position_title: "Accountant",
  hire_date: Date.new(2021, 11, 1),
  leave_balance: 22
)

# Admin
create_user_and_employee(
  email: "admin@example.com",
  role: :admin,
  department: "Administration",
  position_title: "System Administrator",
  hire_date: Date.new(2020, 5, 1),
  leave_balance: 25
)

# Fetch employees by email
ceo         = Hr::Employee.joins(:user).find_by(users: { email: "ceo@example.com" })
cto         = Hr::Employee.joins(:user).find_by(users: { email: "cto@example.com" })
qs          = Hr::Employee.joins(:user).find_by(users: { email: "qs@example.com" })
site_manager= Hr::Employee.joins(:user).find_by(users: { email: "site_manager@example.com" })
engineer    = Hr::Employee.joins(:user).find_by(users: { email: "engineer@example.com" })
storekeeper = Hr::Employee.joins(:user).find_by(users: { email: "storekeeper@example.com" })

# Set up hierarchy
cto.update!(manager: ceo)
qs.update!(manager: cto)
site_manager.update!(manager: qs)
engineer.update!(manager: site_manager)
storekeeper.update!(manager: engineer)
