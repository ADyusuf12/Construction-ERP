require "rails_helper"

RSpec.describe "Inventory::StockMovements", type: :request do
  let(:storekeeper) { create(:user, :storekeeper) }
  let(:site_manager) { create(:user, :site_manager) }
  let(:engineer) { create(:user, :engineer) }

  let!(:item) { create(:inventory_item) }
  let!(:warehouse) { create(:warehouse) }

  describe "GET index" do
    it "requires login" do
      get inventory_inventory_item_stock_movements_path(item), headers: html_headers
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows authorized users to view index" do
      sign_in storekeeper
      get inventory_inventory_item_stock_movements_path(item), headers: html_headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET new" do
    it "renders new for authorized user" do
      sign_in site_manager
      get new_inventory_inventory_item_stock_movement_path(item), headers: html_headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST create" do
    let(:valid_params) do
      {
        stock_movement: {
          destination_warehouse_id: warehouse.id,
          movement_type: :inbound,
          quantity: 5
        }
      }
    end

    context "when not signed in" do
      it "redirects to login" do
        post inventory_inventory_item_stock_movements_path(item), params: valid_params, headers: html_headers
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as storekeeper" do
      before { sign_in storekeeper }

      it "creates and applies a movement" do
        expect {
          post inventory_inventory_item_stock_movements_path(item), params: valid_params, headers: html_headers
        }.to change(StockMovement, :count).by(1)

        expect(response).to redirect_to(inventory_inventory_item_path(item))
        follow_redirect!
        expect(response.body).to include("Movement recorded and applied.")
      end

      it "renders new on validation failure" do
        expect {
          post inventory_inventory_item_stock_movements_path(item),
               params: { stock_movement: { destination_warehouse_id: nil, movement_type: :inbound, quantity: 0 } },
               headers: html_headers
        }.to_not change(StockMovement, :count)

        # controller uses redirect with flash alert on failure
        expect(response).to redirect_to(new_inventory_inventory_item_stock_movement_path(item))
        follow_redirect!
        expect(response.body).to include("Quantity must be greater than 0")
      end
    end

    context "when signed in as engineer (not authorized to create)" do
      before { sign_in engineer }

      it "is not authorized to create" do
        post inventory_inventory_item_stock_movements_path(item), params: valid_params, headers: html_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
