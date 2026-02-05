module Business
  class ClientsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_client, only: %i[show edit update destroy]
    include Pundit::Authorization

    def index
      @clients = policy_scope(Client)
    end

    def show
      authorize @client
    end

    def new
      @client = Client.new
      authorize @client
    end

    def edit
      authorize @client
    end

    def create
      @client = Business::Client.new(client_params)
      authorize @client

      if @client.save
        redirect_to business_client_path(@client), notice: "Client was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      authorize @client
      if @client.update(client_params)
        redirect_to business_client_path(@client), notice: "Client was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      authorize @client
      @client.destroy!
      redirect_to business_clients_path, notice: "Client was successfully destroyed.", status: :see_other
    end

    private

    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:name, :company, :email, :phone, :address, :notes, :user_id)
    end
  end
end
