# spec/services/inventory_manager/movement_applier_spec.rb
require "rails_helper"

RSpec.describe InventoryManager::MovementApplier, type: :service do
  let(:inventory_item) { create(:inventory_item, unit_cost: 2.5) }
  let(:warehouse_src)  { create(:warehouse) }
  let(:warehouse_dst)  { create(:warehouse) }
  let(:project)        { create(:project) }
  let(:task)           { create(:task, project: project) }

  # Helper to ensure a stock level exists for tests
  def ensure_stock(item:, warehouse:, quantity: 10)
    StockLevel.find_or_create_by!(inventory_item: item, warehouse: warehouse).update!(quantity: quantity)
  end

  describe "#call" do
    context "inbound" do
      let(:movement) do
        create(:stock_movement,
               movement_type: :inbound,
               inventory_item: inventory_item,
               destination_warehouse: warehouse_dst,
               quantity: 7,
               unit_cost: 4.0)
      end

      it "creates/updates stock level and sets applied_at" do
        expect(StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_dst)).to be_nil

        described_class.new(movement).call

        level = StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_dst)
        expect(level).not_to be_nil
        expect(level.quantity).to eq(7)
        expect(movement.reload.applied_at).to be_present
      end
    end

    context "outbound" do
      let(:movement) do
        create(:stock_movement,
               :outbound,
               inventory_item: inventory_item,
               source_warehouse: warehouse_src,
               project: project,
               quantity: 4,
               unit_cost: 3.0)
      end

      before do
        ensure_stock(item: inventory_item, warehouse: warehouse_src, quantity: 10)
        ProjectInventory.create!(project: project, inventory_item: inventory_item, warehouse: warehouse_src, quantity_reserved: 6)
      end

      it "decrements stock, updates project inventory and creates a project expense" do
        expect {
          described_class.new(movement).call
        }.to change { StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_src).quantity }.by(-4)
         .and change { ProjectExpense.count }.by(1)

        expect(movement.reload.applied_at).to be_present
        pi = ProjectInventory.find_by(project: project, inventory_item: inventory_item)
        expect(pi.quantity_reserved).to eq(2)
      end

      it "does not apply when insufficient stock and leaves state unchanged" do
        # reduce stock to less than movement quantity
        ensure_stock(item: inventory_item, warehouse: warehouse_src, quantity: 2)

        # Call should not raise; it should rollback and leave no side effects
        expect {
          described_class.new(movement).call
        }.not_to change { ProjectExpense.count }

        # stock level should remain unchanged (2)
        expect(StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_src).quantity).to eq(2)

        # applied_at should not be set
        expect(movement.reload.applied_at).to be_nil
      end
    end

    context "adjustment" do
      let(:movement) do
        create(:stock_movement,
               :adjustment,
               inventory_item: inventory_item,
               destination_warehouse: warehouse_dst,
               quantity: 12)
      end

      before do
        ensure_stock(item: inventory_item, warehouse: warehouse_dst, quantity: 3)
      end

      it "sets stock level to movement quantity" do
        described_class.new(movement).call
        level = StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_dst)
        expect(level.quantity).to eq(12)
      end
    end

    context "site_delivery" do
      let(:movement) do
        create(:stock_movement,
               :site_delivery,
               inventory_item: inventory_item,
               project: project,
               task: task,
               quantity: 3,
               unit_cost: nil) # will fall back to inventory_item.unit_cost
      end

      before do
        # ensure warehouse has stock so ProjectInventory validation passes
        ensure_stock(item: inventory_item, warehouse: warehouse_src, quantity: 10)
        ProjectInventory.create!(project: project, inventory_item: inventory_item, task: task, warehouse: warehouse_src, quantity_reserved: 5)
      end

      it "reduces reservation and creates a project expense using fallback cost" do
        expect {
          described_class.new(movement).call
        }.to change { ProjectExpense.count }.by(1)

        pi = ProjectInventory.find_by(project: project, inventory_item: inventory_item, task: task)
        expect(pi.quantity_reserved).to eq(2) # 5 reserved - 3 delivered
        expect(movement.reload.applied_at).to be_present

        expense = ProjectExpense.last
        expect(expense.amount).to eq(3 * inventory_item.unit_cost)
      end
    end

    context "unit_cost fallback" do
      let(:movement) do
        create(:stock_movement,
               :site_delivery,
               inventory_item: inventory_item,
               project: project,
               task: task,
               quantity: 2,
               unit_cost: nil)
      end

      before do
        ensure_stock(item: inventory_item, warehouse: warehouse_src, quantity: 10)
        ProjectInventory.create!(project: project, inventory_item: inventory_item, task: task, warehouse: warehouse_src, quantity_reserved: 3)
      end

      it "uses inventory_item.unit_cost when movement.unit_cost is nil" do
        described_class.new(movement).call
        expense = ProjectExpense.last
        expect(expense.amount).to eq(2 * inventory_item.unit_cost)
      end
    end
  end
end
