# spec/requests/inventory/inventory_items_spec.rb
require "rails_helper"

RSpec.describe "Inventory::InventoryItems", type: :request do
  let(:ceo)          { create(:user, :ceo) }
  let(:admin)        { create(:user, :admin) }
  let(:site_manager) { create(:user, :site_manager) }
  let(:storekeeper)  { create(:user, :storekeeper) }
  let(:cto)          { create(:user, :cto) }
  let(:engineer)     { create(:user, :engineer) }

  let!(:item)        { create(:inventory_item) }

  describe "GET /inventory/inventory_items" do
    it "requires login" do
      get inventory_inventory_items_path, headers: html_headers
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows authorized users to view index" do
      sign_in cto
      get inventory_inventory_items_path, headers: html_headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /inventory/inventory_items/:id" do
    it "requires login" do
      get inventory_inventory_item_path(item), headers: html_headers
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows various roles to view show" do
      [ ceo, admin, site_manager, storekeeper ].each do |user|
        sign_in user
        get inventory_inventory_item_path(item), headers: html_headers
        expect(response).to have_http_status(:ok)
        sign_out user
      end
    end
  end

  describe "GET /inventory/inventory_items/new" do
    it "redirects unauthenticated users" do
      get new_inventory_inventory_item_path, headers: html_headers
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows create-capable roles to access new" do
      [ ceo, admin, site_manager, storekeeper ].each do |user|
        sign_in user
        get new_inventory_inventory_item_path, headers: html_headers
        expect(response).to have_http_status(:ok)
        sign_out user
      end
    end

    it "denies access to roles without create permission" do
      sign_in cto
      get new_inventory_inventory_item_path, headers: html_headers
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(inventory_inventory_items_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe "POST /inventory/inventory_items" do
    let(:valid_params) do
      { inventory_item: { sku: "SKU-9999", name: "New Material", unit_cost: 9.99, reorder_threshold: 3 } }
    end

    context "when not signed in" do
      it "redirects to login" do
        post inventory_inventory_items_path, params: valid_params, headers: html_headers
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as storekeeper (allowed to create)" do
      before { sign_in storekeeper }

      it "creates an inventory item" do
        expect {
          post inventory_inventory_items_path, params: valid_params, headers: html_headers
        }.to change(InventoryItem, :count).by(1)

        expect(response).to redirect_to(inventory_inventory_item_path(InventoryItem.last))
        follow_redirect!
        expect(response.body).to include("Inventory item created.")
      end

      it "renders new on validation failure" do
        expect {
          post inventory_inventory_items_path, params: { inventory_item: { sku: nil, name: "" } }, headers: html_headers
        }.to_not change(InventoryItem, :count)

        # controller renders with 422; assert numeric status for robustness
        expect(response.status).to eq(422)
      end
    end

    context "when signed in as engineer (not allowed to create)" do
      before { sign_in engineer }

      it "is not authorized to create" do
        post inventory_inventory_items_path, params: valid_params, headers: html_headers
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(inventory_inventory_items_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET /inventory/inventory_items/:id/edit" do
    it "allows edit for update-capable roles" do
      [ ceo, admin, site_manager, storekeeper ].each do |user|
        sign_in user
        get edit_inventory_inventory_item_path(item), headers: html_headers
        expect(response).to have_http_status(:ok)
        sign_out user
      end
    end

    it "denies edit for roles without update permission" do
      sign_in cto
      get edit_inventory_inventory_item_path(item), headers: html_headers
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(inventory_inventory_item_path(item))
      expect(flash[:alert]).to be_present
    end
  end

  describe "PATCH /inventory/inventory_items/:id" do
    let(:update_params) { { inventory_item: { name: "Updated Name" } } }

    context "when signed in as site_manager (allowed to update)" do
      before { sign_in site_manager }

      it "updates the item" do
        patch inventory_inventory_item_path(item), params: update_params, headers: html_headers
        expect(response).to redirect_to(inventory_inventory_item_path(item))
        follow_redirect!
        expect(response.body).to include("Inventory item updated.")
        expect(item.reload.name).to eq("Updated Name")
      end
    end

    context "when signed in as cto (not allowed to update)" do
      before { sign_in cto }

      it "is not authorized to update" do
        patch inventory_inventory_item_path(item), params: update_params, headers: html_headers
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(inventory_inventory_item_path(item))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE /inventory/inventory_items/:id" do
    context "when signed in as admin (allowed to destroy)" do
      before { sign_in admin }

      it "destroys the inventory item" do
        item_to_delete = create(:inventory_item)
        expect {
          delete inventory_inventory_item_path(item_to_delete), headers: html_headers
        }.to change(InventoryItem, :count).by(-1)

        expect(response).to redirect_to(inventory_inventory_items_path)
        follow_redirect!
        expect(response.body).to include("Inventory item removed.")
      end
    end

    context "when signed in as site_manager (not allowed to destroy)" do
      before { sign_in site_manager }

      it "is not authorized to destroy" do
        delete inventory_inventory_item_path(item), headers: html_headers
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(inventory_inventory_items_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
