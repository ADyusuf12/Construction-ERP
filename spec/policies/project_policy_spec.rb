require "rails_helper"

RSpec.describe ProjectPolicy do
  let(:project) { create(:project) }

  context "as CTO" do
    let(:user) { create(:user, :cto) }
    subject { described_class.new(user, project) }

    it "permits all actions" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as Manager" do
    let(:user) { create(:user, :manager) }
    subject { described_class.new(user, project) }

    it "permits create/update but forbids destroy" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(false)
    end
  end

  context "as QS" do
    let(:user) { create(:user, :qs) }
    subject { described_class.new(user, project) }

    it "permits only index/show" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(false)
      expect(subject.update?).to eq(false)
      expect(subject.destroy?).to eq(false)
    end
  end

  context "as Engineer" do
    let(:user) { create(:user, :engineer) }
    subject { described_class.new(user, project) }

    it "permits only index/show" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(false)
      expect(subject.update?).to eq(false)
      expect(subject.destroy?).to eq(false)
    end
  end
end
