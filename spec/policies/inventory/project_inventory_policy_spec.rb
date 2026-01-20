# spec/policies/inventory/project_inventory_policy_spec.rb
require "rails_helper"

RSpec.describe Inventory::ProjectInventoryPolicy do
  let(:project) { create(:project) }
  let(:inventory_item) { create(:inventory_item) }
  let(:project_inventory) { create(:project_inventory, project: project, inventory_item: inventory_item) }

  context "as Admin" do
    let(:user) { create(:user, :admin) }
    subject { described_class.new(user, project_inventory) }

    it "permits create/update/destroy" do
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as Site Manager" do
    let(:user) { create(:user, :site_manager) }
    subject { described_class.new(user, project_inventory) }

    it "permits create and update but not destroy" do
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(false)
    end
  end

  context "as Storekeeper" do
    let(:user) { create(:user, :storekeeper) }
    subject { described_class.new(user, project_inventory) }

    it "permits create/update/destroy" do
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as Engineer not on the project" do
    let(:user) { create(:user, :engineer) }
    subject { described_class.new(user, project_inventory) }

    it "denies create/update/destroy" do
      expect(subject.create?).to eq(false)
      expect(subject.update?).to eq(false)
      expect(subject.destroy?).to eq(false)
    end
  end

  context "as Engineer on the project" do
    let(:user) { create(:user, :engineer) }
    subject { described_class.new(user, project_inventory) }

    before do
      # assign the user to the project via a task -> assignment (matches ProjectPolicy)
      task = create(:task, project: project)
      create(:assignment, task: task, user: user)
    end

    it "permits create/update and allows destroy for project member" do
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as QS" do
    let(:user) { create(:user, :qs) }
    subject { described_class.new(user, project_inventory) }

    it "denies create/update/destroy by default" do
      expect(subject.create?).to eq(false)
      expect(subject.update?).to eq(false)
      expect(subject.destroy?).to eq(false)
    end
  end

  describe "Scope" do
    it "returns only project inventories for engineer/qs limited to their projects (via assignments)" do
      user = create(:user, :engineer)
      project_a = create(:project)
      project_b = create(:project)

      # assign user to project_a via task -> assignment
      task_a = create(:task, project: project_a)
      create(:assignment, task: task_a, user: user)

      pi_a = create(:project_inventory, project: project_a)
      pi_b = create(:project_inventory, project: project_b)

      resolved = Inventory::ProjectInventoryPolicy::Scope.new(user, ProjectInventory.all).resolve
      expect(resolved).to include(pi_a)
      expect(resolved).not_to include(pi_b)
    end

    it "returns all records for non-engineer/qs roles" do
      user = create(:user, :cto)
      pis = create_list(:project_inventory, 2)
      resolved = Inventory::ProjectInventoryPolicy::Scope.new(user, ProjectInventory.all).resolve
      expect(resolved).to match_array(pis)
    end
  end
end
