# --- Updated Helper with base_salary ---
def create_user_and_employee(email:, role:, first_name:, last_name:, department:, position_title:, hire_date:, leave_balance:, gender:, bank_name:, phone_number:, base_salary:)
  user = User.create!(email: email, password: "password", role: role)
  employee = Hr::Employee.create!(
    user: user,
    department: department,
    position_title: position_title,
    hire_date: hire_date,
    status: :active,
    leave_balance: leave_balance,
    base_salary: base_salary
  )
  Hr::PersonalDetail.create!(
    employee: employee,
    first_name: first_name,
    last_name: last_name,
    dob: Date.new(1995, 8, 20),
    gender: gender,
    bank_name: bank_name,
    account_number: SecureRandom.random_number(10**10).to_s.rjust(10, "0"),
    account_name: "#{first_name} #{last_name}",
    means_of_identification: :nin,
    id_number: SecureRandom.hex(6),
    marital_status: :single,
    address: "Satellite Town, Abuja",
    phone_number: phone_number
  )
  employee
end

puts "Seeding Core Personnel..."

# 1. Create Core Management & Staff
ceo = create_user_and_employee(email: "ceo@example.com", role: :ceo, first_name: "Adebola", last_name: "Olawale", department: "Executive", position_title: "Chief Executive Officer", hire_date: Date.new(2020, 1, 1), leave_balance: 30, gender: :male, bank_name: "GTBank", phone_number: "08031234567", base_salary: 1_200_000)
cto = create_user_and_employee(email: "cto@example.com", role: :cto, first_name: "Funmi", last_name: "Adeyemi", department: "Technical", position_title: "Chief Technical Officer", hire_date: Date.new(2021, 1, 1), leave_balance: 25, gender: :female, bank_name: "UBA", phone_number: "08176543210", base_salary: 950_000)
qs = create_user_and_employee(email: "qs@example.com", role: :qs, first_name: "Bola", last_name: "Adeyemi", department: "Quality", position_title: "Quantity Surveyor", hire_date: Date.new(2022, 1, 1), leave_balance: 20, gender: :female, bank_name: "First Bank", phone_number: "08123456700", base_salary: 450_000)
site_mgr = create_user_and_employee(email: "site_manager@example.com", role: :site_manager, first_name: "Emeka", last_name: "Nwosu", department: "Operations", position_title: "Site Manager", hire_date: Date.new(2021, 6, 1), leave_balance: 18, gender: :male, bank_name: "Zenith Bank", phone_number: "09012345678", base_salary: 400_000)
eng = create_user_and_employee(email: "engineer@example.com", role: :engineer, first_name: "Chinedu", last_name: "Okafor", department: "Engineering", position_title: "Civil Engineer", hire_date: Date.new(2022, 3, 1), leave_balance: 15, gender: :male, bank_name: "Access Bank", phone_number: "08123456789", base_salary: 450_000)
store = create_user_and_employee(email: "storekeeper@example.com", role: :storekeeper, first_name: "Aisha", last_name: "Bello", department: "Inventory", position_title: "Storekeeper", hire_date: Date.new(2023, 1, 1), leave_balance: 12, gender: :female, bank_name: "Fidelity Bank", phone_number: "08099887766", base_salary: 180_000)
hr_off = create_user_and_employee(email: "hr@example.com", role: :hr, first_name: "Ngozi", last_name: "Eze", department: "Human Resources", position_title: "HR Officer", hire_date: Date.new(2022, 9, 1), leave_balance: 20, gender: :female, bank_name: "Zenith Bank", phone_number: "09098765432", base_salary: 220_000)
acct = create_user_and_employee(email: "accountant@example.com", role: :accountant, first_name: "Ibrahim", last_name: "Musa", department: "Finance", position_title: "Accountant", hire_date: Date.new(2021, 11, 1), leave_balance: 22, gender: :male, bank_name: "Union Bank", phone_number: "08122334455", base_salary: 300_000)
admin = create_user_and_employee(email: "admin@example.com", role: :admin, first_name: "Samuel", last_name: "Adekunle", department: "Administration", position_title: "System Administrator", hire_date: Date.new(2020, 5, 1), leave_balance: 25, gender: :male, bank_name: "Stanbic IBTC", phone_number: "08044556677", base_salary: 200_000)

# 2. Assign Hierarchy
cto.update!(manager: ceo)
hr_off.update!(manager: ceo)
acct.update!(manager: ceo)
admin.update!(manager: cto)
site_mgr.update!(manager: cto)
eng.update!(manager: site_mgr)
qs.update!(manager: site_mgr)
store.update!(manager: site_mgr)

# 3. Junior Staff (Report to Site Manager)
[
  [ "Tunde", "Bakare", "General Laborer", :male, 85_000 ],
  [ "Oluchi", "Okoro", "Site Cleaner", :female, 75_000 ],
  [ "Abubakar", "Garba", "Security Guard", :male, 80_000 ],
  [ "Timini", "Idris", "Junior Mason", :female, 90_000 ]
].each do |fn, ln, pos, gndr, sal|
  emp = Hr::Employee.create!(
    department: "Field Operations",
    position_title: pos,
    hire_date: Date.today - 6.months,
    status: :active,
    leave_balance: 10,
    manager: site_mgr,
    base_salary: sal
  )
  Hr::PersonalDetail.create!(
    employee: emp, first_name: fn, last_name: ln, dob: Date.new(1995, 5, 12),
    gender: gndr, marital_status: :single, means_of_identification: :nin,
    id_number: SecureRandom.hex(5).upcase, bank_name: "Access Bank",
    account_number: SecureRandom.random_number(10**10).to_s.rjust(10, "0"),
    account_name: "#{fn} #{ln}", phone_number: "070#{rand(10000000..99999999)}",
    address: "Staff Quarters, Abuja"
  )
end

# Business Clients
Business::Client.find_or_create_by!(email: "client1@example.com") do |c|
  c.name = "Dangote Construction Ltd."
end
Business::Client.find_or_create_by!(email: "client2@example.com") do |c|
  c.name = "Julius Berger Nigeria Plc"
end

puts "✅ Employees seeded with base salaries. CEO -> Staff Hierarchy established."
