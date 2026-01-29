# --- Employees with Nigerian names ---
def create_user_and_employee(email:, role:, first_name:, last_name:, department:, position_title:, hire_date:, leave_balance:, gender:, bank_name:, phone_number:)
  user = User.create!(
    email: email,
    password: "password",
    role: role
  )

  employee = Hr::Employee.create!(
    user: user,
    department: department,
    position_title: position_title,
    hire_date: hire_date,
    status: :active,
    leave_balance: leave_balance
  )

  Hr::PersonalDetail.create!(
    employee: employee,
    first_name: first_name,
    last_name: last_name,
    dob: Date.new(1990, 5, 12),
    gender: gender,
    bank_name: bank_name,
    account_number: SecureRandom.random_number(10**10).to_s.rjust(10, "0"),
    account_name: "#{first_name} #{last_name}",
    means_of_identification: :nin,
    id_number: SecureRandom.hex(6),
    marital_status: :married,
    address: "Plot 45, Garki, Abuja",
    phone_number: phone_number
  )

  employee
end

# --- Core Employees ---
create_user_and_employee(email: "ceo@example.com", role: :ceo, first_name: "Adebola", last_name: "Olawale", department: "Executive", position_title: "Chief Executive Officer", hire_date: Date.new(2020,1,1), leave_balance: 30, gender: :male, bank_name: "GTBank", phone_number: "08031234567")

create_user_and_employee(email: "cto@example.com", role: :cto, first_name: "Funmi", last_name: "Adeyemi", department: "Technical", position_title: "Chief Technical Officer", hire_date: Date.new(2021,1,1), leave_balance: 25, gender: :female, bank_name: "UBA", phone_number: "08176543210")

create_user_and_employee(email: "qs@example.com", role: :qs, first_name: "Bola", last_name: "Adeyemi", department: "Quality", position_title: "Quantity Surveyor", hire_date: Date.new(2022,1,1), leave_balance: 20, gender: :female, bank_name: "First Bank", phone_number: "08123456700")

create_user_and_employee(email: "site_manager@example.com", role: :site_manager, first_name: "Emeka", last_name: "Nwosu", department: "Operations", position_title: "Site Manager", hire_date: Date.new(2021,6,1), leave_balance: 18, gender: :male, bank_name: "Zenith Bank", phone_number: "09012345678")

create_user_and_employee(email: "engineer@example.com", role: :engineer, first_name: "Chinedu", last_name: "Okafor", department: "Engineering", position_title: "Civil Engineer", hire_date: Date.new(2022,3,1), leave_balance: 15, gender: :male, bank_name: "Access Bank", phone_number: "08123456789")

create_user_and_employee(email: "storekeeper@example.com", role: :storekeeper, first_name: "Aisha", last_name: "Bello", department: "Inventory", position_title: "Storekeeper", hire_date: Date.new(2023,1,1), leave_balance: 12, gender: :female, bank_name: "Fidelity Bank", phone_number: "08099887766")

create_user_and_employee(email: "hr@example.com", role: :hr, first_name: "Ngozi", last_name: "Eze", department: "Human Resources", position_title: "HR Officer", hire_date: Date.new(2022,9,1), leave_balance: 20, gender: :female, bank_name: "Zenith Bank", phone_number: "09098765432")

create_user_and_employee(email: "accountant@example.com", role: :accountant, first_name: "Ibrahim", last_name: "Musa", department: "Finance", position_title: "Accountant", hire_date: Date.new(2021,11,1), leave_balance: 22, gender: :male, bank_name: "Union Bank", phone_number: "08122334455")

create_user_and_employee(email: "admin@example.com", role: :admin, first_name: "Samuel", last_name: "Adekunle", department: "Administration", position_title: "System Administrator", hire_date: Date.new(2020,5,1), leave_balance: 25, gender: :male, bank_name: "Stanbic IBTC", phone_number: "08044556677")

puts "Seeded Nigerian employees with realistic details."

# --- Business Clients ---
client1_user = User.create!(email: "client1@example.com", password: "password", role: :client)
client2_user = User.create!(email: "client2@example.com", password: "password", role: :client)

Business::Client.create!(user: client1_user, name: "Dangote Construction Ltd.", email: "client1@example.com")
Business::Client.create!(user: client2_user, name: "Julius Berger Nigeria Plc", email: "client2@example.com")
Business::Client.create!(name: "Cappa & D'Alberto Plc", email: "client3@example.com")

puts "Seeded Nigerian business clients."
