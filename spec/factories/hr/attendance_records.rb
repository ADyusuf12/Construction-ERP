FactoryBot.define do
  factory :attendance_record, class: "Hr::AttendanceRecord" do
    association :employee, factory: :hr_employee
    association :project

    date { Date.today }
    status { :present }

    # Default times for present/late records
    check_in_time  { Time.zone.parse("09:00") }
    check_out_time { Time.zone.parse("17:00") }

    trait :present do
      status { :present }
      check_in_time  { Time.zone.parse("09:00") }
      check_out_time { Time.zone.parse("17:00") }
    end

    trait :late do
      status { :late }
      check_in_time  { Time.zone.parse("10:00") }
      check_out_time { Time.zone.parse("17:00") }
    end

    trait :absent do
      status { :absent }
      check_in_time  { nil }
      check_out_time { nil }
    end

    trait :on_leave do
      status { :on_leave }
      check_in_time  { nil }
      check_out_time { nil }
    end
  end
end
