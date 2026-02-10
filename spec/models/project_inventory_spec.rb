require "rails_helper"

RSpec.describe ProjectInventory, type: :model do
  let(:project) { create(:project) }
  let(:item)    { create(:inventory_item) }
  let(:warehouse) { create(:warehouse) }

  describe "associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:inventory_item) }
    it { is_expected.to belong_to(:task).optional }
    it { is_expected.to belong_to(:warehouse).optional }
  end

  describe "validations" do
    it { is_expected.to validate_numericality_of(:quantity_reserved).is_greater_than_or_equal_to(0).only_integer }

    context "warehouse stock validation" do
      let(:pi) { build(:project_inventory, project: project, inventory_item: item, warehouse: warehouse, quantity_reserved: 20) }

      before do
        StockLevel.create!(inventory_item: item, warehouse: warehouse, quantity: 5)
      end

      it "adds an error if reserved quantity exceeds stock" do
        expect(pi).not_to be_valid
        expect(pi.errors[:quantity_reserved]).to include("exceeds available stock in warehouse (5)")
      end
    end
  end

  describe "callbacks" do
    before do
      StockLevel.create!(inventory_item: item, warehouse: warehouse, quantity: 10)
    end
    it "touches inventory_item after commit" do
      pi = create(:project_inventory, project: project, inventory_item: item, warehouse: warehouse)
      expect { pi.update!(quantity_reserved: 3) }.to change { item.reload.updated_at }
    end
  end

  describe "custom methods" do
    before do
      StockLevel.create!(inventory_item: item, warehouse: warehouse, quantity: 10)
    end
    let!(:pi) { create(:project_inventory, project: project, inventory_item: item, warehouse: warehouse, quantity_reserved: 5) }

    before do
      # Create stock movements
      create(:stock_movement, :outbound, project: project, inventory_item: item, quantity: 2, applied_at: Time.current)
      create(:stock_movement, :site_delivery, project: project, inventory_item: item, quantity: 1, applied_at: Time.current)
    end

    it "#issued_quantity sums outbound and site_delivery movements" do
      expect(pi.issued_quantity).to eq(3)
    end

    it "#outstanding_reservation returns reserved minus issued" do
      expect(pi.outstanding_reservation).to eq(2) # 5 reserved - 3 issued
    end

    it "#site_quantity equals issued_quantity" do
      expect(pi.site_quantity).to eq(3)
    end
  end
  describe "#cancel!" do
    let(:pi) { create(:project_inventory, project: project, inventory_item: item, warehouse: warehouse, quantity_reserved: 5) }

    before do
      StockLevel.create!(inventory_item: item, warehouse: warehouse, quantity: 10)
    end

    it "sets quantity_reserved to 0 and records cancellation" do
      pi.cancel!(reason: "No longer needed")
      expect(pi.quantity_reserved).to eq(0)
      expect(pi.cancelled?).to be true
      expect(pi.cancellation_reason).to eq("No longer needed")
    end

    it "is idempotent" do
      pi.cancel!(reason: "First cancel")
      expect { pi.cancel!(reason: "Second cancel") }.not_to change { pi.reload.cancellation_reason }
    end
  end
end
