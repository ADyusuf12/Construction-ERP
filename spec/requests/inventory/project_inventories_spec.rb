require "rails_helper"

RSpec.describe "Inventory::ProjectInventories", type: :request do
  let(:ceo)            { create(:user, :ceo) }
  let(:admin)          { create(:user, :admin) }
  let(:site_manager)   { create(:user, :site_manager) }
  let(:storekeeper)    { create(:user, :storekeeper) }
  let(:engineer)       { create(:user, :engineer) }
  let(:other_engineer) { create(:user, :engineer) }

  let!(:project)       { create(:project) }
  let!(:item)          { create(:inventory_item) }
  let!(:existing_pi)   { create(:project_inventory, project: project, inventory_item: item, quantity_reserved: 2) }

  let(:referer) { project_path(project) }

  describe "POST /inventory/project_inventories" do
    let(:params) do
      { project_inventory: { project_id: project.id, inventory_item_id: item.id, quantity_reserved: 3 } }
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
             params: { project_inventory: { project_id: project.id, inventory_item_id: nil, quantity_reserved: -1 } },
             headers: referer_headers(referer)

        expect(response).to redirect_to(referer)
        follow_redirect!
        expect(response.body).to include("can't be blank").or include("must be greater than or equal to")
      end
    end

    context "when signed in as engineer assigned to the project" do
      before do
        task = create(:task, project: project)
        create(:assignment, task: task, user: engineer)
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
    let(:update_params) { { project_inventory: { quantity_reserved: 5 } } }

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
        create(:assignment, task: task, user: engineer)
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
  end

  describe "DELETE /inventory/project_inventories/:id" do
    context "when signed in as admin (allowed to destroy)" do
      before { sign_in admin }

      it "destroys the reservation and redirects back with notice" do
        pi_item = create(:inventory_item)
        pi = create(:project_inventory, project: project, inventory_item: pi_item)
        expect {
          delete inventory_project_inventory_path(pi), headers: referer_headers(referer)
        }.to change(ProjectInventory, :count).by(-1)

        expect(response).to redirect_to(referer)
        follow_redirect!
        expect(response.body).to include("Reservation removed.")
      end
    end

    context "when signed in as storekeeper (allowed to destroy)" do
      before { sign_in storekeeper }

      it "destroys the reservation" do
        pi_item = create(:inventory_item)
        pi = create(:project_inventory, project: project, inventory_item: pi_item)
        expect {
          delete inventory_project_inventory_path(pi), headers: referer_headers(referer)
        }.to change(ProjectInventory, :count).by(-1)
      end
    end

    context "when signed in as site_manager (not allowed to destroy)" do
      before { sign_in site_manager }

      it "is not authorized to destroy" do
        delete inventory_project_inventory_path(existing_pi), headers: referer_headers(referer)
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(project_path(project))
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end

    context "when signed in as engineer who belongs to the project" do
      before do
        task = create(:task, project: project)
        create(:assignment, task: task, user: engineer)
        sign_in engineer
      end

      it "allows destroying the reservation" do
        pi_item = create(:inventory_item)
        pi = create(:project_inventory, project: project, inventory_item: pi_item)
        expect {
          delete inventory_project_inventory_path(pi), headers: referer_headers(referer)
        }.to change(ProjectInventory, :count).by(-1)

        expect(response).to redirect_to(referer)
      end
    end
  end
end
