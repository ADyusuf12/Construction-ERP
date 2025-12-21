require 'rails_helper'

RSpec.describe "Hr::Employees", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/hr/employees/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/hr/employees/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/hr/employees/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/hr/employees/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
