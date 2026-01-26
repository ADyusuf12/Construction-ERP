module Inventory
  class WarehousesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_warehouse, only: %i[show edit update destroy]

    def index
      @warehouses = policy_scope([ :inventory, Warehouse ]).order(:name)
    end

    def show
      authorize [ :inventory, @warehouse ]

      @inventory_items = @warehouse.inventory_items.includes(:stock_levels)

      @inventory_totals = @warehouse.stock_levels
                                    .group(:inventory_item_id)
                                    .sum(:quantity)

      @recent_movements = @warehouse.recent_movements(10)
    end

    def new
      @warehouse = Warehouse.new
      authorize [ :inventory, @warehouse ]
    end

    def create
      @warehouse = Warehouse.new(warehouse_params)
      authorize [ :inventory, @warehouse ]
      if @warehouse.save
        redirect_to inventory_warehouse_path(@warehouse), notice: "Warehouse created."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
      authorize [ :inventory, @warehouse ]
    end

    def update
      authorize [ :inventory, @warehouse ]
      if @warehouse.update(warehouse_params)
        redirect_to inventory_warehouse_path(@warehouse), notice: "Warehouse updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      authorize [ :inventory, @warehouse ]
      @warehouse.destroy
      redirect_to inventory_warehouses_path, notice: "Warehouse removed."
    end

    private

    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end

    def warehouse_params
      params.require(:warehouse).permit(:name, :address, :code)
    end
  end
end
