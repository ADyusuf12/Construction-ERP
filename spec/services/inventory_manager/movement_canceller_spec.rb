# spec/services/inventory_manager/movement_canceller_spec.rb
require "rails_helper"

RSpec.describe InventoryManager::MovementCanceller, type: :service do
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
    context "cancel inbound" do
      let(:movement) do
        create(:stock_movement,
               movement_type: :inbound,
               inventory_item: inventory_item,
               destination_warehouse: warehouse_dst,
               quantity: 7)
      end

      it "decrements stock level when inbound is cancelled and removes linked expense" do
        # apply first
        InventoryManager::MovementApplier.new(movement).call

        # ensure expense has a project (project_id is NOT NULL)
        expense_project = movement.project || create(:project)
        expense = ProjectExpense.create!(
          date: Date.today,
          description: "manual",
          amount: 10,
          project: expense_project,
          stock_movement: movement
        )

        expect {
          described_class.new(movement).call
        }.to change {
          StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_dst).quantity
        }.by(-7)

        expect(ProjectExpense.where(id: expense.id)).to be_empty
      end
    end

    context "cancel outbound" do
      let(:movement) do
        create(:stock_movement,
               :outbound,
               inventory_item: inventory_item,
               source_warehouse: warehouse_src,
               project: project,
               quantity: 4)
      end

      before do
        ensure_stock(item: inventory_item, warehouse: warehouse_src, quantity: 10)
        ProjectInventory.create!(project: project, inventory_item: inventory_item, warehouse: warehouse_src, quantity_reserved: 6)
        InventoryManager::MovementApplier.new(movement).call
      end

      it "restores stock and reservation and deletes linked expense" do
        # create linked expense to ensure deletion
        expense = ProjectExpense.create!(date: Date.today, description: "movement", amount: 12, stock_movement: movement, project: project)

        expect {
          described_class.new(movement).call
        }.to change { StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_src).quantity }.by(4)

        pi = ProjectInventory.find_by(project: project, inventory_item: inventory_item)
        expect(pi.quantity_reserved).to eq(6)
        expect(ProjectExpense.where(id: expense.id)).to be_empty
      end
    end

    context "cancel site_delivery" do
      let(:movement) do
        create(:stock_movement,
               :site_delivery,
               inventory_item: inventory_item,
               project: project,
               task: task,
               quantity: 3)
      end

      before do
        ensure_stock(item: inventory_item, warehouse: warehouse_src, quantity: 10)
        ProjectInventory.create!(project: project, inventory_item: inventory_item, task: task, warehouse: warehouse_src, quantity_reserved: 5)
        InventoryManager::MovementApplier.new(movement).call
      end

      it "restores reservation on cancel" do
        expect {
          described_class.new(movement).call
        }.to change {
          ProjectInventory.find_by(project: project, inventory_item: inventory_item, task: task).quantity_reserved
        }.by(3)
      end
    end

    context "cancel adjustment" do
      let(:movement) do
        create(:stock_movement,
               :adjustment,
               inventory_item: inventory_item,
               destination_warehouse: warehouse_dst,
               quantity: 12)
      end

      before do
        ensure_stock(item: inventory_item, warehouse: warehouse_dst, quantity: 3)
        InventoryManager::MovementApplier.new(movement).call
      end

      it "resets stock level to 0 on cancel" do
        described_class.new(movement).call
        expect(StockLevel.find_by(inventory_item: inventory_item, warehouse: warehouse_dst).quantity).to eq(0)
      end
    end

    context "linked expense deletion" do
      let(:movement) do
        create(:stock_movement,
               :site_delivery,
               inventory_item: inventory_item,
               project: project,
               task: task,
               quantity: 1)
      end

      before do
        ensure_stock(item: inventory_item, warehouse: warehouse_src, quantity: 10)
        ProjectInventory.create!(project: project, inventory_item: inventory_item, task: task, warehouse: warehouse_src, quantity_reserved: 2)
        InventoryManager::MovementApplier.new(movement).call
      end

      it "destroys the project_expense associated with the movement" do
        expect(movement.project_expense).to be_present
        described_class.new(movement).call
        expect(ProjectExpense.where(stock_movement_id: movement.id)).to be_empty
      end
    end
  end
end
