require "rails_helper"

RSpec.describe "Transactions", type: :request do
  let(:project)     { create(:project) }
  let(:transaction) { create(:transaction, project: project) }
  let(:user)        { create(:user, :ceo) } # CEO has full permissions

  before { sign_in user }

  describe "GET /transactions" do
    it "returns success" do
      get transactions_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /transactions/:id" do
    it "returns success" do
      get transaction_path(transaction)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /transactions" do
    context "with valid params" do
      it "creates a transaction" do
        expect {
          post transactions_path, params: {
            transaction: {
              project_id: project.id,
              date: Date.today,
              description: "New Transaction",
              amount: 500,
              transaction_type: "invoice",
              status: "unpaid"
            }
          }
        }.to change(Transaction, :count).by(1)

        expect(response).to redirect_to(transactions_path)
        expect(Transaction.last.description).to eq("New Transaction")
      end
    end

    context "with invalid params" do
      it "does not create a transaction" do
        expect {
          post transactions_path, params: {
            transaction: {
              project_id: project.id,
              date: nil, # invalid
              description: "",
              amount: -10,
              transaction_type: "invoice",
              status: "unpaid"
            }
          }
        }.not_to change(Transaction, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /transactions/:id" do
    it "updates a transaction" do
      patch transaction_path(transaction), params: {
        transaction: { description: "Updated Transaction" }
      }
      expect(response).to redirect_to(transactions_path)
      expect(transaction.reload.description).to eq("Updated Transaction")
    end
  end

  describe "PATCH /transactions/:id/mark_paid" do
    it "marks transaction as paid" do
      patch mark_paid_transaction_path(transaction)
      expect(response).to redirect_to(transactions_path)
      expect(transaction.reload.status).to eq("paid")
    end
  end

  describe "DELETE /transactions/:id" do
    it "deletes a transaction" do
      transaction # ensure created
      expect {
        delete transaction_path(transaction)
      }.to change(Transaction, :count).by(-1)
      expect(response).to redirect_to(transactions_path)
    end
  end
end
