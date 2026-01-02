require "rails_helper"

RSpec.describe ReportPolicy do
  let(:project) { create(:project) }
  let(:author)  { create(:user) }
  let(:report)  { create(:report, project: project, user: author, status: :draft) }

  describe "CEO" do
    let(:user)   { create(:user, :ceo) }
    let(:policy) { described_class.new(user, report) }

    it "allows broad actions but not update/submit on non-authored draft" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq false   # not the author
      expect(policy.destroy?).to eq true
      expect(policy.submit?).to eq false   # not the author
      expect(policy.review?).to eq false
    end

    it "allows review when submitted" do
      submitted_report = create(:report, project: project, user: author, status: :submitted)
      expect(described_class.new(user, submitted_report).review?).to eq true
    end
  end

  describe "Manager" do
    let(:user)   { create(:user, :site_manager) }
    let(:policy) { described_class.new(user, report) }

    it "allows index, show, create but not update/destroy/submit on non-authored draft" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq false
      expect(policy.destroy?).to eq false
      expect(policy.submit?).to eq false
      expect(policy.review?).to eq false
    end

    it "allows review when submitted" do
      submitted_report = create(:report, project: project, user: author, status: :submitted)
      expect(described_class.new(user, submitted_report).review?).to eq true
    end
  end

  describe "Author" do
    let(:policy) { described_class.new(author, report) }

    it "can update and submit draft" do
      expect(policy.update?).to eq true
      expect(policy.submit?).to eq true
    end

    it "cannot destroy or review" do
      expect(policy.destroy?).to eq false
      expect(policy.review?).to eq false
    end
  end

  describe "Engineer (non-author)" do
    let(:user)   { create(:user, :engineer) }
    let(:policy) { described_class.new(user, report) }

    it "cannot view or manage non-authored report" do
      expect(policy.index?).to eq false
      expect(policy.show?).to eq false
      expect(policy.create?).to eq false
      expect(policy.update?).to eq false
      expect(policy.destroy?).to eq false
      expect(policy.submit?).to eq false
      expect(policy.review?).to eq false
    end
  end
end
