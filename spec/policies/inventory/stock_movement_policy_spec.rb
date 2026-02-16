# spec/policies/inventory/stock_movement_policy_spec.rb
require "rails_helper"

RSpec.describe Inventory::StockMovementPolicy, type: :policy do
  subject(:policy) { described_class.new(user, stock_movement) }

  let(:ceo)          { create(:user, :ceo) }
  let(:admin)        { create(:user, :admin) }
  let(:site_manager) { create(:user, :site_manager) }
  let(:storekeeper)  { create(:user, :storekeeper) }
  let(:cto)          { create(:user, :cto) }
  let(:engineer)     { create(:user, :engineer) }
  let(:other_eng)    { create(:user, :engineer) }
  let(:qs)           { create(:user, :qs) }
  let(:hr)           { create(:user, :hr) }
  let(:guest)        { nil }

  let!(:inventory_item) { create(:inventory_item) }
  let!(:stock_movement) { create(:stock_movement, inventory_item: inventory_item) }

  # Helper to ensure a warehouse has stock for an item (satisfies ProjectInventory validation)
  def ensure_stock(item:, warehouse:, quantity: 10)
    StockLevel.find_or_create_by!(inventory_item: item, warehouse: warehouse).update!(quantity: quantity)
  end

  describe "action permissions" do
    context "index? and show?" do
      it "delegates to InventoryItemPolicy#show? (true case)" do
        allow_any_instance_of(Inventory::InventoryItemPolicy).to receive(:show?).and_return(true)
        expect(described_class.new(hr, stock_movement).index?).to be true
        expect(described_class.new(hr, stock_movement).show?).to be true
      end

      it "delegates to InventoryItemPolicy#show? (false case)" do
        allow_any_instance_of(Inventory::InventoryItemPolicy).to receive(:show?).and_return(false)
        expect(described_class.new(engineer, stock_movement).index?).to be false
        expect(described_class.new(engineer, stock_movement).show?).to be false
      end
    end

    context "create?" do
      it "allows CEO, Admin, Site Manager, Storekeeper (match InventoryItemPolicy#create?)" do
        [ ceo, admin, site_manager, storekeeper ].each do |u|
          expect(described_class.new(u, stock_movement).create?).to be true
        end
      end

      it "denies CTO (not in InventoryItemPolicy#create?)" do
        expect(described_class.new(cto, stock_movement).create?).to be false
      end

      it "allows engineer when movement is for a project the user belongs to" do
        project = create(:project)
        task = create(:task, project: project)
        create(:assignment, task: task, employee: engineer.employee)

        warehouse = create(:warehouse)
        ensure_stock(item: inventory_item, warehouse: warehouse, quantity: 10)
        create(:project_inventory, project: project, inventory_item: inventory_item, warehouse: warehouse)

        expect(described_class.new(engineer, stock_movement).create?).to be true
      end

      it "denies engineer when movement is not for user's project" do
        expect(described_class.new(other_eng, stock_movement).create?).to be false
      end

      it "denies QS (not in InventoryItemPolicy#create?) even if assigned" do
        project = create(:project)
        task = create(:task, project: project)
        create(:assignment, task: task, employee: qs.employee)

        warehouse = create(:warehouse)
        ensure_stock(item: inventory_item, warehouse: warehouse, quantity: 10)
        create(:project_inventory, project: project, inventory_item: inventory_item, warehouse: warehouse)

        expect(described_class.new(qs, stock_movement).create?).to be false
      end

      it "denies guest (nil user)" do
        expect(described_class.new(guest, stock_movement).create?).to be false
      end
    end

    context "update?" do
      it "allows CEO, Admin, Site Manager, Storekeeper (match InventoryItemPolicy#update?)" do
        [ ceo, admin, site_manager, storekeeper ].each do |u|
          expect(described_class.new(u, stock_movement).update?).to be true
        end
      end

      it "denies CTO, engineer, qs, guest" do
        [ cto, engineer, qs, other_eng, nil ].each do |u|
          expect(described_class.new(u, stock_movement).update?).to be false
        end
      end
    end

    context "destroy?" do
      it "allows CEO, Admin, Storekeeper (match InventoryItemPolicy#destroy?)" do
        [ ceo, admin, storekeeper ].each do |u|
          expect(described_class.new(u, stock_movement).destroy?).to be true
        end
      end

      it "denies CTO, site_manager, engineer, qs, guest" do
        [ cto, site_manager, engineer, qs, other_eng, nil ].each do |u|
          expect(described_class.new(u, stock_movement).destroy?).to be false
        end
      end
    end
  end

  describe "Scope" do
    subject(:resolved) { described_class::Scope.new(user, StockMovement.all).resolve }

    let!(:project_a) { create(:project) }
    let!(:project_b) { create(:project) }

    let!(:item_for_a) { create(:inventory_item) }
    let!(:item_for_b) { create(:inventory_item) }
    let!(:item_global) { create(:inventory_item) }

    let!(:movement_a) { create(:stock_movement, inventory_item: item_for_a) }
    let!(:movement_b) { create(:stock_movement, inventory_item: item_for_b) }
    let!(:movement_global) { create(:stock_movement, inventory_item: item_global) }

    before do
      warehouse_a = create(:warehouse)
      warehouse_b = create(:warehouse)

      ensure_stock(item: item_for_a, warehouse: warehouse_a, quantity: 10)
      ensure_stock(item: item_for_b, warehouse: warehouse_b, quantity: 10)

      create(:project_inventory, project: project_a, inventory_item: item_for_a, warehouse: warehouse_a)
      create(:project_inventory, project: project_b, inventory_item: item_for_b, warehouse: warehouse_b)
      # item_global has no project_inventories
    end

    context "for admin" do
      let(:user) { admin }

      it "returns all movements" do
        expect(resolved).to include(movement_a, movement_b, movement_global)
      end
    end

    context "for engineer assigned to project_a" do
      let(:user) { engineer }

      before do
        task = create(:task, project: project_a)
        create(:assignment, task: task, employee: engineer.employee)
      end

      it "returns only movements tied to the user's projects" do
        expect(resolved).to include(movement_a)
        expect(resolved).not_to include(movement_b)
        expect(resolved).not_to include(movement_global)
      end
    end

    context "for qs assigned to project_b" do
      let(:user) { qs }

      before do
        task = create(:task, project: project_b)
        create(:assignment, task: task, employee: qs.employee)
      end

      it "returns only movements tied to the user's projects" do
        expect(resolved).to include(movement_b)
        expect(resolved).not_to include(movement_a)
        expect(resolved).not_to include(movement_global)
      end
    end

    context "for engineer not assigned to any project" do
      let(:user) { other_eng }

      it "returns no project-scoped movements" do
        expect(resolved).to be_empty
      end
    end
  end
end
