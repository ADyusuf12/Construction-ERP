require "rails_helper"

RSpec.describe "Admin::Users", type: :request do
  let(:admin)       { create(:user, :admin) }
  let(:ceo)         { create(:user, :ceo) }
  let(:engineer)    { create(:user, :engineer) }
  let!(:user)       { create(:user, :engineer) } # sample record to view/edit/delete

  describe "GET /admin/users" do
    it "requires login" do
      get admin_users_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows logged in Admin" do
      sign_in admin
      get admin_users_path
      expect(response).to have_http_status(:ok)
    end

    it "denies non-admin (CEO)" do
      sign_in ceo
      get admin_users_path
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(root_path)
    end

    it "denies non-admin (Engineer)" do
      sign_in engineer
      get admin_users_path
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(root_path)
    end
  end

  describe "GET /admin/users/:id" do
    it "allows Admin to view" do
      sign_in admin
      get admin_user_path(user)
      expect(response).to have_http_status(:ok)
    end

    it "denies non-admin" do
      sign_in engineer
      get admin_user_path(user)
      expect(response).to redirect_to(dashboard_home_path).or redirect_to(root_path)
    end
  end

  describe "POST /admin/users" do
    context "as Admin" do
      it "creates a new user" do
        sign_in admin
        expect {
          post admin_users_path, params: {
            user: {
              email: "newuser@hamzis.com",
              password: "password",
              role: "engineer"
            }
          }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(admin_users_path)
      end
    end

    context "as non-admin" do
      it "is not authorized" do
        sign_in engineer
        post admin_users_path, params: { user: { email: "bad@hamzis.com", password: "password" } }
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(root_path)
      end
    end
  end

  describe "PATCH /admin/users/:id" do
    context "as Admin" do
      it "updates the user" do
        sign_in admin
        patch admin_user_path(user), params: { user: { email: "updated@hamzis.com" } }
        expect(response).to redirect_to(admin_users_path)
        expect(user.reload.email).to eq("updated@hamzis.com")
      end
    end

    context "as non-admin" do
      it "is not authorized" do
        sign_in engineer
        patch admin_user_path(user), params: { user: { email: "updated@hamzis.com" } }
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(root_path)
      end
    end
  end

  describe "DELETE /admin/users/:id" do
    context "as Admin" do
      it "destroys the user" do
        sign_in admin
        expect {
          delete admin_user_path(user)
        }.to change(User, :count).by(-1)
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context "as non-admin" do
      it "is not authorized" do
        sign_in engineer
        delete admin_user_path(user)
        expect(response).to redirect_to(dashboard_home_path).or redirect_to(root_path)
      end
    end
  end
end
