# spec/models/stock_movement_spec.rb
require "rails_helper"

RSpec.describe StockMovement, type: :model do
  let(:inventory_item) { create(:inventory_item, unit_cost: 2.5) }
  let(:warehouse_src)  { create(:warehouse) }
  let(:warehouse_dst)  { create(:warehouse) }
  let(:project)        { create(:project) }
  let(:task)           { create(:task, project: project) }

  # Helper to ensure a stock level exists
  def ensure_stock(item:, warehouse:, quantity: 10)
    StockLevel.find_or_create_by!(inventory_item: item, warehouse: warehouse).update!(quantity: quantity)
  end

  describe "associations and enums" do
    it { is_expected.to belong_to(:inventory_item) }
    it { is_expected.to belong_to(:source_warehouse).class_name("Warehouse").optional }
    it { is_expected.to belong_to(:destination_warehouse).class_name("Warehouse").optional }
    it { is_expected.to belong_to(:project).optional }
    it { is_expected.to belong_to(:task).optional }

    it "defines movement_type enum" do
      expect(StockMovement.movement_types.keys).to include("inbound", "outbound", "adjustment", "site_delivery")
    end
  end

  describe "scopes and cancelled?" do
    let!(:active_movement)    { create(:stock_movement, movement_type: :inbound) }
    let!(:cancelled_movement) { create(:stock_movement, movement_type: :inbound, cancelled_at: 1.day.ago) }

    it "active scope excludes cancelled movements" do
      expect(StockMovement.active).to include(active_movement)
      expect(StockMovement.active).not_to include(cancelled_movement)
    end

    it "cancelled? returns true when cancelled_at present" do
      expect(cancelled_movement.cancelled?).to be true
      expect(active_movement.cancelled?).to be false
    end
  end

  describe "apply! and cancel! lifecycle" do
    context "inbound" do
      let(:movement) do
        create(:stock_movement,
               movement_type: :inbound,
               inventory_item: inventory_item,
               destination_warehouse: warehouse_dst,
               quantity: 7,
               unit_cost: 4.0)
      end

      it "increases stock level and sets applied_at" do
        expect(StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_dst)).to be_nil

        movement.apply!

        level = StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_dst)
        expect(level).not_to be_nil
        expect(level.quantity).to eq(7)
        expect(movement.reload.applied_at).to be_present
      end

      it "reverses inbound on cancel! and deletes linked expense" do
        movement.apply!

        # create a project for the expense (project_id is NOT NULL in schema)
        expense_project = movement.project || create(:project)
        expense = ProjectExpense.create!(
          date: Date.today,
          description: "manual",
          amount: 10,
          project: expense_project,
          stock_movement: movement
        )

        expect {
          movement.cancel!(reason: "test")
        }.to change {
          StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_dst).quantity
        }.by(-7)

        expect(movement.reload.cancelled?).to be true
        expect(ProjectExpense.where(id: expense.id)).to be_empty
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

      it "decrements stock level, updates project inventory and creates project expense" do
        expect {
          movement.apply!
        }.to change { StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_src).quantity }.by(-4)
         .and change { ProjectExpense.count }.by(1)

        expect(movement.reload.applied_at).to be_present

        pi = ProjectInventory.find_by(project: project, inventory_item: inventory_item)
        expect(pi.quantity_reserved).to eq(2)
      end

      it "restores stock and reservation on cancel!" do
        movement.apply!
        expect {
          movement.cancel!(reason: "undo")
        }.to change { StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_src).quantity }.by(4)

        pi = ProjectInventory.find_by(project: project, inventory_item: inventory_item)
        expect(pi.quantity_reserved).to eq(6)
        expect(movement.reload.cancelled?).to be true
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

      it "sets stock level to movement quantity on apply!" do
        movement.apply!
        level = StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_dst)
        expect(level.quantity).to eq(12)
      end

      it "resets stock level to 0 on cancel!" do
        movement.apply!
        movement.cancel!(reason: "revert")
        expect(StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_dst).quantity).to eq(0)
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
        ensure_stock(item: inventory_item, warehouse: warehouse_src, quantity: 10)
        ProjectInventory.create!(project: project, inventory_item: inventory_item, task: task, warehouse: warehouse_src, quantity_reserved: 5)
      end

      it "creates a project expense and reduces reservation on apply!" do
        expect {
          movement.apply!
        }.to change { ProjectExpense.count }.by(1)

        pi = ProjectInventory.find_by(project: project, inventory_item: inventory_item, task: task)
        expect(pi.quantity_reserved).to eq(2)
        expect(movement.reload.applied_at).to be_present
      end

      it "restores reservation on cancel!" do
        movement.apply!
        expect {
          movement.cancel!(reason: "undo")
        }.to change {
          ProjectInventory.find_by(project: project, inventory_item: inventory_item, task: task).quantity_reserved
        }.by(3)
      end
    end
  end
end
