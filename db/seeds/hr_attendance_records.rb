# Pick employees from seeded users
engineer     = User.find_by(email: "engineer@example.com").employee
qs           = User.find_by(email: "qs@example.com").employee
site_manager = User.find_by(email: "site_manager@example.com").employee

# Pick projects
project1 = Project.find_by(name: "Headquarters Construction")
project2 = Project.find_by(name: "Warehouse Expansion")

# Seed attendance records
Hr::AttendanceRecord.create!(
  employee: engineer,
  project: project1,
  date: Date.today,
  status: :present,
  check_in_time: Time.current.change(hour: 8),
  check_out_time: Time.current.change(hour: 17)
)

Hr::AttendanceRecord.create!(
  employee: qs,
  project: project2,
  date: Date.today,
  status: :late,
  check_in_time: Time.current.change(hour: 10),
  check_out_time: Time.current.change(hour: 17)
)

Hr::AttendanceRecord.create!(
  employee: site_manager,
  project: project1,
  date: Date.today,
  status: :absent
)

puts "Seeded attendance records for engineer, QS, and site manager."
