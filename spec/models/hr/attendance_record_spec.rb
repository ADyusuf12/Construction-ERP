require "rails_helper"

RSpec.describe Hr::AttendanceRecord, type: :model do
  let(:employee) { create(:hr_employee) }
  let(:project)  { create(:project) }

  describe "validations" do
    it "is valid with required attributes" do
      record = build(:attendance_record, employee: employee, project: project,
                                         date: Date.today, status: :present,
                                         check_in_time: "09:00", check_out_time: "17:00")
      expect(record).to be_valid
    end

    it "requires a date" do
      record = build(:attendance_record, date: nil)
      expect(record).not_to be_valid
      expect(record.errors[:date]).to include("can't be blank")
    end

    it "requires a status" do
      record = build(:attendance_record, status: nil)
      expect(record).not_to be_valid
      expect(record.errors[:status]).to include("can't be blank")
    end

    context "when status is present" do
      it "requires check_in_time and check_out_time" do
        record = build(:attendance_record, status: :present, check_in_time: nil, check_out_time: nil)
        expect(record).not_to be_valid
        expect(record.errors[:check_in_time]).to include("can't be blank")
        expect(record.errors[:check_out_time]).to include("can't be blank")
      end
    end

    context "when status is late" do
      it "requires check_in_time and check_out_time" do
        record = build(:attendance_record, status: :late, check_in_time: nil, check_out_time: nil)
        expect(record).not_to be_valid
        expect(record.errors[:check_in_time]).to include("can't be blank")
        expect(record.errors[:check_out_time]).to include("can't be blank")
      end
    end

    context "when status is absent" do
      it "does not require check_in_time or check_out_time" do
        record = build(:attendance_record, status: :absent, check_in_time: nil, check_out_time: nil)
        expect(record).to be_valid
      end
    end

    context "when status is on_leave" do
      it "does not require check_in_time or check_out_time" do
        record = build(:attendance_record, status: :on_leave, check_in_time: nil, check_out_time: nil)
        expect(record).to be_valid
      end
    end
  end

  describe "custom validation check_out_after_check_in" do
    it "is valid when check_out_time is after check_in_time" do
      record = build(:attendance_record, status: :present,
                                         check_in_time: Time.zone.parse("09:00"),
                                         check_out_time: Time.zone.parse("17:00"))
      expect(record).to be_valid
    end

    it "is invalid when check_out_time is before check_in_time" do
      record = build(:attendance_record, status: :present,
                                         check_in_time: Time.zone.parse("17:00"),
                                         check_out_time: Time.zone.parse("09:00"))
      expect(record).not_to be_valid
      expect(record.errors[:check_out_time]).to include("must be after check-in time")
    end

    it "skips validation if either time is blank for non-working statuses" do
      record = build(:attendance_record, status: :absent, check_in_time: nil, check_out_time: nil)
      expect(record).to be_valid
    end
  end

  describe "enums" do
    it "defines statuses correctly" do
      expect(described_class.statuses.keys).to contain_exactly("present", "absent", "late", "on_leave")
    end

    it "allows prefix methods" do
      record = build(:attendance_record, status: :present)
      expect(record.status_present?).to eq(true)
      expect(record.status_absent?).to eq(false)
    end
  end
end
