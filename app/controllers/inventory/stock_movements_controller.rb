class Inventory::StockMovementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_inventory_item, except: %i[index show]
  before_action :set_stock_movement, only: %i[show edit update destroy]

  def index
    if params[:inventory_item_id].present?
      # Nested case: movements for a specific item
      @inventory_item = InventoryItem.find(params[:inventory_item_id])
      @stock_movements = policy_scope([:inventory, @inventory_item.stock_movements])
                            .includes(:inventory_item, :project, :employee, :source_warehouse, :destination_warehouse)
                            .order(created_at: :desc)
      authorize [ :inventory, @inventory_item ]
    else
      # Global case: all movements
      @stock_movements = policy_scope([:inventory, StockMovement])
                            .includes(:inventory_item, :project, :employee, :source_warehouse, :destination_warehouse)
                            .order(created_at: :desc)
      authorize [:inventory, StockMovement]
    end

    @summary = {
      inbound: @stock_movements.where(movement_type: :inbound).count,
      outbound: @stock_movements.where(movement_type: :outbound).count,
      site_delivery: @stock_movements.where(movement_type: :site_delivery).count,
      adjustments: @stock_movements.where(movement_type: :adjustment).count
    }
  end

  def show
    authorize [:inventory, @stock_movement]
  end

  def new
    @stock_movement = @inventory_item.stock_movements.build(movement_type: nil)
    authorize [:inventory, @stock_movement]
  end

  def create
    @stock_movement = @inventory_item.stock_movements.build(
      stock_movement_params.merge(employee: current_user.employee)
    )
    authorize [:inventory, @stock_movement]

    if @stock_movement.save
      begin
        @stock_movement.apply!
        redirect_to inventory_inventory_item_path(@inventory_item), notice: "Movement recorded and applied."
      rescue => e
        flash[:alert] = "Movement recorded but failed to apply: #{e.message}"
        redirect_to inventory_inventory_item_path(@inventory_item)
      end
    else
      flash[:alert] = @stock_movement.errors.full_messages.to_sentence
      redirect_to new_inventory_inventory_item_stock_movement_path(@inventory_item)
    end
  end

  def edit
    authorize [:inventory, @stock_movement]
  end

  def update
    authorize [:inventory, @stock_movement]

    if @stock_movement.update(stock_movement_params)
      begin
        @stock_movement.apply!
        redirect_to inventory_inventory_item_path(@inventory_item), notice: "Movement updated and applied."
      rescue => e
        flash[:alert] = "Movement updated but failed to apply: #{e.message}"
        redirect_to inventory_inventory_item_path(@inventory_item)
      end
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize [:inventory, @stock_movement]
    @stock_movement.destroy
    redirect_to inventory_inventory_item_path(@inventory_item), notice: "Movement removed."
  end

  private

  def set_inventory_item
    return unless params[:inventory_item_id].present?
    @inventory_item = policy_scope([:inventory, InventoryItem]).find(params[:inventory_item_id])
  end

  def set_stock_movement
    if params[:inventory_item_id].present?
      @stock_movement = InventoryItem.find(params[:inventory_item_id]).stock_movements.find(params[:id])
    else
      @stock_movement = StockMovement.find(params[:id])
    end
  end

  def stock_movement_params
    params.require(:stock_movement).permit(
      :movement_type, :quantity, :unit_cost, :reference, :notes,
      :project_id, :task_id, :source_warehouse_id, :destination_warehouse_id
    )
  end
end
