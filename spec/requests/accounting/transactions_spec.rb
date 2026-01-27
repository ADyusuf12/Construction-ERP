RSpec.describe "Accounting::Transactions", type: :request do
  let(:transaction) { create(:accounting_transaction) }
  let(:user)        { create(:user, :ceo) } # CEO has full permissions

  before { sign_in user, scope: :user }

  describe "GET /accounting/transactions" do
    it "returns success" do
      get accounting_transactions_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /accounting/transactions/:id" do
    it "returns success" do
      get accounting_transaction_path(transaction)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /accounting/transactions" do
    context "with valid params" do
      it "creates a transaction" do
        expect {
          post accounting_transactions_path, params: {
            accounting_transaction: {
              date: Date.today,
              description: "New Transaction",
              amount: 500,
              transaction_type: "invoice",
              status: "unpaid"
            }
          }
        }.to change(Accounting::Transaction, :count).by(1)

        expect(response).to redirect_to(accounting_transactions_path)
        expect(Accounting::Transaction.last.description).to eq("New Transaction")
      end
    end

    context "with invalid params" do
      it "does not create a transaction" do
        expect {
          post accounting_transactions_path, params: {
            accounting_transaction: {
              date: nil, # invalid
              description: "",
              amount: -10,
              transaction_type: "invoice",
              status: "unpaid"
            }
          }
        }.not_to change(Accounting::Transaction, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /accounting/transactions/:id" do
    it "updates a transaction" do
      patch accounting_transaction_path(transaction), params: {
        accounting_transaction: { description: "Updated Transaction" }
      }
      expect(response).to redirect_to(accounting_transactions_path)
      expect(transaction.reload.description).to eq("Updated Transaction")
    end
  end

  describe "PATCH /accounting/transactions/:id/mark_paid" do
    it "marks transaction as paid" do
      patch mark_paid_accounting_transaction_path(transaction)
      expect(response).to redirect_to(accounting_transactions_path)
      expect(transaction.reload.status).to eq("paid")
    end
  end

  describe "DELETE /accounting/transactions/:id" do
    it "deletes a transaction" do
      transaction # ensure created
      expect {
        delete accounting_transaction_path(transaction)
      }.to change(Accounting::Transaction, :count).by(-1)
      expect(response).to redirect_to(accounting_transactions_path)
    end
  end
end
