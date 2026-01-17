# spec/requests/inventory/warehouses_spec.rb
require "rails_helper"

RSpec.describe "Inventory::Warehouses", type: :request do
  let(:ceo)          { create(:user, :ceo) }
  let(:admin)        { create(:user, :admin) }
  let(:site_manager) { create(:user, :site_manager) }
  let(:storekeeper)  { create(:user, :storekeeper) }
  let(:cto)          { create(:user, :cto) }
  let(:engineer)     { create(:user, :engineer) }

  let!(:warehouse)   { create(:warehouse) }

  describe "GET /inventory/warehouses" do
    it "requires login" do
      get inventory_warehouses_path, headers: html_headers
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows authorized users to view index" do
      sign_in cto
      get inventory_warehouses_path, headers: html_headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /inventory/warehouses/:id" do
    it "requires login" do
      get inventory_warehouse_path(warehouse), headers: html_headers
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows various roles to view show" do
      [ ceo, admin, cto, site_manager, storekeeper ].each do |user|
        sign_in user
        get inventory_warehouse_path(warehouse), headers: html_headers
        expect(response).to have_http_status(:ok)
        sign_out user
      end
    end
  end

  describe "GET /inventory/warehouses/new" do
    it "redirects unauthenticated users" do
      get new_inventory_warehouse_path, headers: html_headers
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows create-capable roles to access new" do
      [ ceo, admin, site_manager, storekeeper ].each do |user|
        sign_in user
        get new_inventory_warehouse_path, headers: html_headers
        expect(response).to have_http_status(:ok)
        sign_out user
      end
    end

    it "denies access to roles without create permission" do
      sign_in cto
      get new_inventory_warehouse_path, headers: html_headers
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(inventory_warehouses_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe "POST /inventory/warehouses" do
    let(:valid_params) do
      { warehouse: { name: "Central Depot", code: "WH999", address: "1 Depot Lane" } }
    end

    context "when not signed in" do
      it "redirects to login" do
        post inventory_warehouses_path, params: valid_params, headers: html_headers
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as admin (allowed to create)" do
      before { sign_in admin }

      it "creates a warehouse" do
        expect {
          post inventory_warehouses_path, params: valid_params, headers: html_headers
        }.to change(Warehouse, :count).by(1)

        expect(response).to redirect_to(inventory_warehouse_path(Warehouse.last))
        follow_redirect!
        expect(response.body).to include("Warehouse created.")
      end

      it "renders new on validation failure" do
        expect {
          post inventory_warehouses_path, params: { warehouse: { name: "" } }, headers: html_headers
        }.to_not change(Warehouse, :count)

        # controller renders with 422; assert numeric status for robustness
        expect(response.status).to eq(422)
      end
    end

    context "when signed in as cto (not allowed to create)" do
      before { sign_in cto }

      it "is not authorized to create" do
        post inventory_warehouses_path, params: valid_params, headers: html_headers
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(inventory_warehouses_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET /inventory/warehouses/:id/edit" do
    it "allows edit for update-capable roles" do
      [ ceo, admin, site_manager, storekeeper ].each do |user|
        sign_in user
        get edit_inventory_warehouse_path(warehouse), headers: html_headers
        expect(response).to have_http_status(:ok)
        sign_out user
      end
    end

    it "denies edit for roles without update permission" do
      sign_in cto
      get edit_inventory_warehouse_path(warehouse), headers: html_headers
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(inventory_warehouse_path(warehouse))
      expect(flash[:alert]).to be_present
    end
  end

  describe "PATCH /inventory/warehouses/:id" do
    let(:update_params) { { warehouse: { name: "Updated Name" } } }

    context "when signed in as site_manager (allowed to update)" do
      before { sign_in site_manager }

      it "updates the warehouse" do
        patch inventory_warehouse_path(warehouse), params: update_params, headers: html_headers
        expect(response).to redirect_to(inventory_warehouse_path(warehouse))
        follow_redirect!
        expect(response.body).to include("Warehouse updated.")
        expect(warehouse.reload.name).to eq("Updated Name")
      end
    end

    context "when signed in as cto (not allowed to update)" do
      before { sign_in cto }

      it "is not authorized to update" do
        patch inventory_warehouse_path(warehouse), params: update_params, headers: html_headers
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(inventory_warehouse_path(warehouse))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE /inventory/warehouses/:id" do
    context "when signed in as admin (allowed to destroy)" do
      before { sign_in admin }

      it "destroys the warehouse" do
        w = create(:warehouse)
        expect {
          delete inventory_warehouse_path(w), headers: html_headers
        }.to change(Warehouse, :count).by(-1)

        expect(response).to redirect_to(inventory_warehouses_path)
        follow_redirect!
        expect(response.body).to include("Warehouse removed.")
      end
    end

    context "when signed in as site_manager (not allowed to destroy)" do
      before { sign_in site_manager }

      it "is not authorized to destroy" do
        delete inventory_warehouse_path(warehouse), headers: html_headers
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(inventory_warehouses_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
