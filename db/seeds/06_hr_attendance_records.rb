# Pick employees from seeded users
engineer     = User.find_by!(email: "engineer@example.com").employee
qs           = User.find_by!(email: "qs@example.com").employee
site_manager = User.find_by!(email: "site_manager@example.com").employee

# Pick projects (MATCHING THE NEW NAMES FROM FILE 02)
project1 = Project.find_by!(name: "Abuja HQ Tower Construction")
project2 = Project.find_by!(name: "Lagos Warehouse Expansion")

# --- TODAY'S RECORDS ---
Hr::AttendanceRecord.create!(
  employee: engineer,
  project: project1,
  date: Date.today,
  status: :present,
  check_in_time: Time.current.change(hour: 8, min: 15),
  check_out_time: Time.current.change(hour: 17, min: 0)
)

Hr::AttendanceRecord.create!(
  employee: qs,
  project: project2,
  date: Date.today,
  status: :late,
  check_in_time: Time.current.change(hour: 10, min: 30),
  check_out_time: Time.current.change(hour: 17, min: 45)
)

Hr::AttendanceRecord.create!(
  employee: site_manager,
  project: project1,
  date: Date.today,
  status: :absent
)

# --- HISTORICAL RECORDS (For Chart Data) ---
# Create some records for the last 3 days so the "Pulse" dashboard looks busy
(1..3).each do |days_ago|
  date = Date.today - days_ago.days

  [ engineer, qs, site_manager ].each do |emp|
    # Alternate projects for variety
    target_project = (emp == qs) ? project2 : project1

    Hr::AttendanceRecord.create!(
      employee: emp,
      project: target_project,
      date: date,
      status: :present,
      check_in_time: date.to_time.change(hour: 8, min: rand(0..30)),
      check_out_time: date.to_time.change(hour: 17, min: rand(0..30))
    )
  end
end

puts "Seeded attendance records (Today + 3 Days History) for Engineer, QS, and Site Manager."
