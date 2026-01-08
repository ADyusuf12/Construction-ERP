module Hr
  class PersonalDetailsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_personal_detail, only: %i[ show edit update destroy ]

    # GET /hr/personal_details
    def index
      authorize Hr::PersonalDetail
      @personal_details = policy_scope(Hr::PersonalDetail)
    end

    # GET /hr/personal_details/:id
    def show
      authorize @personal_detail
    end

    # GET /hr/personal_details/new
    def new
      @personal_detail = Hr::PersonalDetail.new
      authorize @personal_detail
    end

    # GET /hr/personal_details/:id/edit
    def edit
      authorize @personal_detail
    end

    # POST /hr/personal_details
    def create
      @personal_detail = Hr::PersonalDetail.new(personal_detail_params)
      authorize @personal_detail

      if @personal_detail.save
        redirect_to hr_personal_details_path, notice: "Personal detail was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    # PATCH/PUT /hr/personal_details/:id
    def update
      authorize @personal_detail
      if @personal_detail.update(personal_detail_params)
        redirect_to hr_personal_details_path, notice: "Personal detail was successfully updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    # DELETE /hr/personal_details/:id
    def destroy
      authorize @personal_detail
      @personal_detail.destroy
      redirect_to hr_personal_details_path, notice: "Personal detail was successfully deleted."
    end

    private

      def set_personal_detail
        @personal_detail = Hr::PersonalDetail.find(params[:id])
      end

      def personal_detail_params
        params.require(:hr_personal_detail).permit(
          :employee_id, :first_name, :last_name, :dob, :gender,
          :bank_name, :account_number, :account_name,
          :means_of_identification, :id_number, :marital_status,
          :address, :phone_number
        )
      end
  end
end
