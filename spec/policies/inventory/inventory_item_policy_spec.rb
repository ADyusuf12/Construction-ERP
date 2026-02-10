# spec/policies/inventory/inventory_item_policy_spec.rb
require "rails_helper"

RSpec.describe Inventory::InventoryItemPolicy do
  let(:inventory_item) { create(:inventory_item) }

  # Helper to ensure a warehouse has stock for an item (satisfies ProjectInventory validation)
  def ensure_stock(item:, warehouse:, quantity: 10)
    StockLevel.find_or_create_by!(inventory_item: item, warehouse: warehouse).update!(quantity: quantity)
  end

  context "as CTO" do
    let(:user) { create(:user, :cto) }
    subject { described_class.new(user, inventory_item) }

    it "denies all actions" do
      expect(subject.index?).to eq(false)
      expect(subject.show?).to eq(false)
      expect(subject.create?).to eq(false)
      expect(subject.update?).to eq(false)
      expect(subject.destroy?).to eq(false)
    end
  end

  context "as Site Manager" do
    let(:user) { create(:user, :site_manager) }
    subject { described_class.new(user, inventory_item) }

    it "permits index/show/create/update but forbids destroy" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(false)
    end
  end

  context "as QS" do
    let(:user) { create(:user, :qs) }
    subject { described_class.new(user, inventory_item) }

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
    subject { described_class.new(user, inventory_item) }

    it "permits only index/show by default" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(false)
      expect(subject.update?).to eq(false)
      expect(subject.destroy?).to eq(false)
    end
  end

  context "as Storekeeper" do
    let(:user) { create(:user, :storekeeper) }
    subject { described_class.new(user, inventory_item) }

    it "permits index/show/create/update and destroy" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  context "as Admin" do
    let(:user) { create(:user, :admin) }
    subject { described_class.new(user, inventory_item) }

    it "permits all actions" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end
  end

  describe "Scope" do
    it "limits engineers and QS to items linked to their projects (via assignments)" do
      user = create(:user, :engineer)

      project = create(:project)
      task = create(:task, project: project)
      create(:assignment, task: task, user: user)

      linked_item = create(:inventory_item)
      warehouse = create(:warehouse)
      ensure_stock(item: linked_item, warehouse: warehouse, quantity: 10)
      create(:project_inventory, project: project, inventory_item: linked_item, warehouse: warehouse, quantity_reserved: 1)

      other_item = create(:inventory_item)

      resolved = Inventory::InventoryItemPolicy::Scope.new(user, InventoryItem.all).resolve

      expect(resolved).to include(linked_item)
      expect(resolved).not_to include(other_item)
    end

    it "returns all items for non-engineer/qs roles" do
      user = create(:user, :cto)
      items = create_list(:inventory_item, 2)
      resolved = Inventory::InventoryItemPolicy::Scope.new(user, InventoryItem.all).resolve
      expect(resolved).to match_array(items)
    end
  end
end
