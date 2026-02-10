# spec/policies/inventory/project_inventory_policy_spec.rb
require "rails_helper"

RSpec.describe Inventory::ProjectInventoryPolicy do
  let(:project) { create(:project) }
  let(:inventory_item) { create(:inventory_item) }

  # Helper to ensure a warehouse has stock for an item (satisfies ProjectInventory validation)
  def ensure_stock(item:, warehouse:, quantity: 10)
    StockLevel.find_or_create_by!(inventory_item: item, warehouse: warehouse).update!(quantity: quantity)
  end

  # create a warehouse and a valid project_inventory for tests
  let(:warehouse) { create(:warehouse) }
  let(:project_inventory) do
    ensure_stock(item: inventory_item, warehouse: warehouse, quantity: 10)
    create(:project_inventory, project: project, inventory_item: inventory_item, warehouse: warehouse)
  end

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

      task_a = create(:task, project: project_a)
      create(:assignment, task: task_a, user: user)

      warehouse_a = create(:warehouse)
      warehouse_b = create(:warehouse)

      ensure_stock(item: inventory_item, warehouse: warehouse_a, quantity: 10)
      ensure_stock(item: inventory_item, warehouse: warehouse_b, quantity: 10)

      pi_a = create(:project_inventory, project: project_a, inventory_item: inventory_item, warehouse: warehouse_a)
      pi_b = create(:project_inventory, project: project_b, inventory_item: inventory_item, warehouse: warehouse_b)

      resolved = Inventory::ProjectInventoryPolicy::Scope.new(user, ProjectInventory.all).resolve
      expect(resolved).to include(pi_a)
      expect(resolved).not_to include(pi_b)
    end

    it "returns all records for non-engineer/qs roles" do
      user = create(:user, :cto)
      warehouse1 = create(:warehouse)
      warehouse2 = create(:warehouse)
      ensure_stock(item: inventory_item, warehouse: warehouse1, quantity: 10)
      ensure_stock(item: inventory_item, warehouse: warehouse2, quantity: 10)

      pis = create_list(:project_inventory, 2, inventory_item: inventory_item, warehouse: warehouse1)
      resolved = Inventory::ProjectInventoryPolicy::Scope.new(user, ProjectInventory.all).resolve
      expect(resolved).to match_array(pis)
    end
  end
end
