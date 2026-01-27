# spec/requests/business/clients_spec.rb
require "rails_helper"

RSpec.describe "Business::Clients", type: :request do
  let(:ceo)    { create(:user, :ceo) }
  let(:hr)     { create(:user, :hr) }
  let(:client_user) { create(:user, :client) }
  let(:engineer) { create(:user, :engineer) }

  let!(:client) { create(:business_client, user: client_user) }

  describe "GET /business/clients" do
    it "requires login" do
      get business_clients_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows CEO" do
      sign_in ceo
      get business_clients_path
      expect(response).to have_http_status(:ok)
    end

    it "allows HR" do
      sign_in hr
      get business_clients_path
      expect(response).to have_http_status(:ok)
    end

    it "allows Client user to see only their own client" do
      sign_in client_user
      get business_clients_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(client.name)
      expect(response.body).not_to include("Other Client")
    end
  end

  describe "POST /business/clients" do
    let(:valid_params) { { client: { name: "New Client", email: "new@example.com" } } }

    context "as CEO" do
      it "creates a client" do
        sign_in ceo
        expect {
          post business_clients_path, params: valid_params
        }.to change(Business::Client, :count).by(1)

        new_client = Business::Client.last
        expect(response).to redirect_to(business_client_path(new_client))
        follow_redirect!
        expect(response.body).to include("Client was successfully created.")
      end
    end

    context "as Client user" do
      it "is not authorized" do
        sign_in client_user
        post business_clients_path, params: valid_params
        expect(response).to redirect_to(dashboard_home_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end
  end

  describe "DELETE /business/clients/:id" do
    context "as HR" do
      it "destroys the client" do
        sign_in hr
        expect {
          delete business_client_path(client)
        }.to change(Business::Client, :count).by(-1)

        expect(response).to redirect_to(business_clients_path)
        follow_redirect!
        expect(response.body).to include("Client was successfully destroyed.")
      end
    end

    context "as Client user" do
      it "is not authorized to destroy" do
        sign_in client_user
        delete business_client_path(client)
        expect(response).to redirect_to(dashboard_home_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end
  end
end
