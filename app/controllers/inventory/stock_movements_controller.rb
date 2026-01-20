# app/controllers/inventory/stock_movements_controller.rb
class Inventory::StockMovementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_inventory_item
  before_action :set_stock_movement, only: %i[edit update destroy]

  def index
    @stock_movements = policy_scope([ :inventory, @inventory_item.stock_movements ]).order(created_at: :desc)
    authorize [ :inventory, @inventory_item ]
  end

  def show
    authorize [ :inventory, @stock_movement ]
  end

  def new
    @stock_movement = @inventory_item.stock_movements.build
    authorize [ :inventory, @stock_movement ]
  end

  def create
    @stock_movement = @inventory_item.stock_movements.build(
      stock_movement_params.merge(employee: current_user.employee)
    )
    authorize [ :inventory, @stock_movement ]

    if @stock_movement.save
      redirect_to inventory_inventory_item_path(@inventory_item), notice: "Movement recorded."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize [ :inventory, @stock_movement ]
  end

  def update
    authorize [ :inventory, @stock_movement ]

    if @stock_movement.update(stock_movement_params)
      redirect_to inventory_inventory_item_path(@inventory_item), notice: "Movement updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize [ :inventory, @stock_movement ]
    @stock_movement.destroy
    redirect_to inventory_inventory_item_path(@inventory_item), notice: "Movement removed."
  end

  private

  def set_inventory_item
    @inventory_item = policy_scope([ :inventory, InventoryItem ]).find(params[:inventory_item_id])
  end

  def set_stock_movement
    @stock_movement = @inventory_item.stock_movements.find(params[:id])
  end

  def stock_movement_params
    params.require(:stock_movement).permit(:movement_type, :quantity, :warehouse_id, :reference, :notes, :unit_cost, :project_id, :task_id)
  end
end
