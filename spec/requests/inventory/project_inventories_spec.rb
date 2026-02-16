require "rails_helper"

RSpec.describe "Inventory::ProjectInventories", type: :request do
  let(:ceo)            { create(:user, :ceo) }
  let(:admin)          { create(:user, :admin) }
  let(:site_manager)   { create(:user, :site_manager) }
  let(:storekeeper)    { create(:user, :storekeeper) }
  let(:engineer)       { create(:user, :engineer) }
  let(:other_engineer) { create(:user, :engineer) }

  let!(:project)   { create(:project) }
  let!(:warehouse) { create(:warehouse) }
  let!(:item)      { create(:inventory_item) }

  # Ensure warehouse has stock for the item used in tests
  let!(:stock_level) do
    StockLevel.find_or_create_by!(inventory_item: item, warehouse: warehouse).tap do |sl|
      sl.update!(quantity: 10)
    end
  end

  # helper to create a project inventory with stock
  def create_pi_for(item:, reserved: 2)
    StockLevel.find_or_create_by!(inventory_item: item, warehouse: warehouse).update!(quantity: 10)
    create(:project_inventory, project: project, inventory_item: item, warehouse: warehouse, quantity_reserved: reserved)
  end

  let!(:existing_pi) { create_pi_for(item: item, reserved: 2) }

  let(:referer) { project_path(project) }

  describe "POST /inventory/project_inventories" do
    let(:params) do
      {
        project_inventory: {
          project_id: project.id,
          inventory_item_id: item.id,
          quantity_reserved: 3,
          warehouse_id: warehouse.id
        }
      }
    end

    context "when not signed in" do
      it "redirects to login" do
        post inventory_project_inventories_path, params: params, headers: referer_headers(referer)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as storekeeper (allowed)" do
      before { sign_in storekeeper }

      it "creates or updates a reservation and redirects back with notice" do
        expect {
          post inventory_project_inventories_path, params: params, headers: referer_headers(referer)
        }.to change(ProjectInventory, :count).by(0).or change(ProjectInventory, :count).by(1)

        expect(response).to redirect_to(referer)
        follow_redirect!
        expect(response.body).to include("Reserved items for project.").or include("Reservation updated.")
      end

      it "returns an alert on validation failure" do
        post inventory_project_inventories_path,
             params: { project_inventory: { project_id: project.id, inventory_item_id: nil, quantity_reserved: -1, warehouse_id: warehouse.id } },
             headers: referer_headers(referer)

        expect(response).to redirect_to(referer)
        follow_redirect!
        expect(response.body).to include("can't be blank").or include("must be greater than or equal to")
      end
    end

    context "when signed in as engineer assigned to the project" do
      before do
        task = create(:task, project: project)
        create(:assignment, task: task, employee: engineer.employee)
        sign_in engineer
      end

      it "allows creating a reservation" do
        expect {
          post inventory_project_inventories_path, params: params, headers: referer_headers(referer)
        }.to change(ProjectInventory, :count).by(0).or change(ProjectInventory, :count).by(1)

        expect(response).to redirect_to(referer)
      end
    end

    context "when signed in as engineer not assigned to the project" do
      before { sign_in other_engineer }

      it "is not authorized to create a reservation" do
        post inventory_project_inventories_path, params: params, headers: referer_headers(referer)
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(project_path(project))
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end
  end

  describe "PATCH /inventory/project_inventories/:id" do
    let(:update_params) { { project_inventory: { quantity_reserved: 5, warehouse_id: warehouse.id } } }

    context "when signed in as site_manager (allowed to update)" do
      before { sign_in site_manager }

      it "updates the reservation and redirects back with notice" do
        patch inventory_project_inventory_path(existing_pi), params: update_params, headers: referer_headers(referer)
        expect(response).to redirect_to(referer)
        follow_redirect!
        expect(response.body).to include("Reservation updated.")
        expect(existing_pi.reload.quantity_reserved).to eq(5)
      end
    end

    context "when signed in as engineer assigned to the project" do
      before do
        task = create(:task, project: project)
        create(:assignment, task: task, employee: engineer.employee)
        sign_in engineer
      end

      it "allows updating the reservation" do
        patch inventory_project_inventory_path(existing_pi), params: update_params, headers: referer_headers(referer)
        expect(response).to redirect_to(referer)
        follow_redirect!
        expect(response.body).to include("Reservation updated.")
        expect(existing_pi.reload.quantity_reserved).to eq(5)
      end
    end

    context "when signed in as engineer not assigned" do
      before { sign_in other_engineer }

      it "is not authorized to update" do
        patch inventory_project_inventory_path(existing_pi), params: update_params, headers: referer_headers(referer)
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(project_path(project))
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end

    context "validation failure on update" do
      before { sign_in site_manager }

      it "redirects back with validation alert and does not change value" do
        patch inventory_project_inventory_path(existing_pi), params: { project_inventory: { quantity_reserved: -10, warehouse_id: warehouse.id } }, headers: referer_headers(referer)
        expect(response).to redirect_to(referer)
        follow_redirect!
        expect(response.body).to include("must be greater than or equal to")
        expect(existing_pi.reload.quantity_reserved).not_to eq(-10)
      end
    end
  end

  describe "DELETE /inventory/project_inventories/:id" do
    context "when signed in as admin (allowed to cancel)" do
      before { sign_in admin }

      it "cancels the reservation and redirects back with notice" do
        pi_item = create(:inventory_item)
        StockLevel.find_or_create_by!(inventory_item: pi_item, warehouse: warehouse).update!(quantity: 5)
        pi = create(:project_inventory, project: project, inventory_item: pi_item, warehouse: warehouse, quantity_reserved: 2)

        delete inventory_project_inventory_path(pi), headers: referer_headers(referer)

        expect(response).to redirect_to(referer)
        follow_redirect!
        expect(response.body).to include("Reservation cancelled.")
        expect(pi.reload.quantity_reserved).to eq(0)
      end
    end

    context "when signed in as storekeeper (allowed to cancel)" do
      before { sign_in storekeeper }

      it "cancels the reservation" do
        pi_item = create(:inventory_item)
        StockLevel.find_or_create_by!(inventory_item: pi_item, warehouse: warehouse).update!(quantity: 5)
        pi = create(:project_inventory, project: project, inventory_item: pi_item, warehouse: warehouse, quantity_reserved: 2)

        delete inventory_project_inventory_path(pi), headers: referer_headers(referer)

        expect(response).to redirect_to(referer)
        expect(pi.reload.quantity_reserved).to eq(0)
      end
    end

    context "when signed in as site_manager (not allowed to cancel)" do
      before { sign_in site_manager }

      it "is not authorized to cancel" do
        delete inventory_project_inventory_path(existing_pi), headers: referer_headers(referer)
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(project_path(project))
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end

    context "when signed in as engineer who belongs to the project" do
      before do
        task = create(:task, project: project)
        create(:assignment, task: task, employee: engineer.employee)
        sign_in engineer
      end

      it "allows cancelling the reservation" do
        pi_item = create(:inventory_item)
        StockLevel.find_or_create_by!(inventory_item: pi_item, warehouse: warehouse).update!(quantity: 5)
        pi = create(:project_inventory, project: project, inventory_item: pi_item, warehouse: warehouse, quantity_reserved: 2)

        delete inventory_project_inventory_path(pi), headers: referer_headers(referer)

        expect(response).to redirect_to(referer)
        follow_redirect!
        expect(response.body).to include("Reservation cancelled.")
        expect(pi.reload.quantity_reserved).to eq(0)
      end
    end

    context "idempotent cancel" do
      before { sign_in admin }

      it "handles cancelling an already cancelled reservation gracefully" do
        pi_item = create(:inventory_item)
        StockLevel.find_or_create_by!(inventory_item: pi_item, warehouse: warehouse).update!(quantity: 5)
        pi = create(:project_inventory, project: project, inventory_item: pi_item, warehouse: warehouse, quantity_reserved: 2)

        delete inventory_project_inventory_path(pi), headers: referer_headers(referer)
        expect(response).to redirect_to(referer)

        delete inventory_project_inventory_path(pi), headers: referer_headers(referer)
        expect(response).to redirect_to(referer)
        follow_redirect!
        expect(response.body).to include("Reservation cancelled.")
      end
    end
  end
end
