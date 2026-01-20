module Accounting
  class DeductionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_deduction, only: %i[ show edit update destroy ]

    # GET /accounting/deductions
    # Optionally scoped to a salary
    def index
      authorize Accounting::Deduction
      @deductions = policy_scope(Accounting::Deduction)
    end

    # GET /accounting/deductions/:id
    def show
      authorize @deduction
    end

    # GET /accounting/deductions/new
    def new
      @deduction = Accounting::Deduction.new
      authorize @deduction
    end

    # GET /accounting/deductions/:id/edit
    def edit
      authorize @deduction
    end

    # POST /accounting/deductions
    def create
      @deduction = Accounting::Deduction.new(deduction_params)
      authorize @deduction

      if @deduction.save
        redirect_to accounting_deductions_path, notice: "Deduction was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    # PATCH/PUT /accounting/deductions/:id
    def update
      authorize @deduction
      if @deduction.update(deduction_params)
        redirect_to accounting_deductions_path, notice: "Deduction was successfully updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    # DELETE /accounting/deductions/:id
    def destroy
      authorize @deduction
      @deduction.destroy
      redirect_to accounting_deductions_path, notice: "Deduction was successfully deleted."
    end

    private

      def set_deduction
        @deduction = Accounting::Deduction.find(params[:id])
      end

      def deduction_params
        params.require(:accounting_deduction).permit(
          :salary_id, :deduction_type, :amount, :notes
        )
      end
  end
end
