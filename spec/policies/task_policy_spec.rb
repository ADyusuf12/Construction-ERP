require "rails_helper"

RSpec.describe TaskPolicy do
  let(:project) { create(:project) }
  let(:task)    { create(:task, project: project) }

  describe "CEO" do
    let(:user)   { create(:user, :ceo) }
    let(:policy) { described_class.new(user, task) }

    it "allows all actions" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq true
      expect(policy.update?).to eq true
      expect(policy.destroy?).to eq true
      expect(policy.mark_in_progress?).to eq true
      expect(policy.mark_done?).to eq true
    end
  end

  describe "Engineer" do
    let(:user)   { create(:user, :engineer) }
    let(:policy) { described_class.new(user, task) }

    it "allows viewing but not managing" do
      expect(policy.index?).to eq true
      expect(policy.show?).to eq true
      expect(policy.create?).to eq false
      expect(policy.update?).to eq false
      expect(policy.destroy?).to eq false
      expect(policy.mark_in_progress?).to eq false
      expect(policy.mark_done?).to eq false
    end
  end
end
