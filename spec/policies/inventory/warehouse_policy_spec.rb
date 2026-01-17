require "rails_helper"

RSpec.describe Inventory::WarehousePolicy do
  let(:warehouse) { create(:warehouse) }
  subject { described_class.new(user, warehouse) }

  context "as CEO" do
    let(:user) { create(:user, :ceo) }

    it "permits all actions" do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be true
      expect(subject.update?).to be true
      expect(subject.destroy?).to be true
    end
  end

  context "as Admin" do
    let(:user) { create(:user, :admin) }

    it "permits all actions" do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be true
      expect(subject.update?).to be true
      expect(subject.destroy?).to be true
    end
  end

  context "as CTO" do
    let(:user) { create(:user, :cto) }

    it "permits viewing only" do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end
  end

  context "as Site Manager" do
    let(:user) { create(:user, :site_manager) }

    it "permits view, create, update but not destroy" do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be true
      expect(subject.update?).to be true
      expect(subject.destroy?).to be false
    end
  end

  context "as Storekeeper" do
    let(:user) { create(:user, :storekeeper) }

    it "permits view, create, update but not destroy" do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be true
      expect(subject.update?).to be true
      expect(subject.destroy?).to be false
    end
  end

  context "as HR" do
    let(:user) { create(:user, :hr) }

    it "permits viewing only" do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end
  end

  context "as Accountant" do
    let(:user) { create(:user, :accountant) }

    it "permits viewing only" do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end
  end

  describe "Scope" do
    it "returns all warehouses for any role" do
      user = create(:user, :cto)
      warehouses = create_list(:warehouse, 2)
      resolved = Inventory::WarehousePolicy::Scope.new(user, Warehouse.all).resolve
      expect(resolved).to match_array(warehouses)
    end
  end
end
