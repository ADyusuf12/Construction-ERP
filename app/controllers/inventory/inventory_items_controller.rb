# app/controllers/inventory/inventory_items_controller.rb
class Inventory::InventoryItemsController < ApplicationController
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :set_inventory_item, only: %i[show edit update destroy]

  def index
    @inventory_items = policy_scope([ :inventory, InventoryItem ]).order(:name)
    if params[:q].present?
      @inventory_items = @inventory_items.where(
        "name ILIKE ? OR sku ILIKE ?",
        "%#{params[:q]}%", "%#{params[:q]}%"
      )
    end

    item_ids = @inventory_items.pluck(:id)
    totals = StockLevel.where(inventory_item_id: item_ids)
                       .group(:inventory_item_id)
                       .sum(:quantity)
    @inventory_totals = totals.with_indifferent_access
  end

  def show
    authorize [ :inventory, @inventory_item ]
    @stock_movements = @inventory_item.stock_movements.order(created_at: :desc).limit(25)
  end

  def new
    @inventory_item = InventoryItem.new
    authorize [ :inventory, @inventory_item ]
  end

  def create
    @inventory_item = InventoryItem.new(inventory_item_params)
    authorize [ :inventory, @inventory_item ]

    if @inventory_item.save
      redirect_to inventory_inventory_item_path(@inventory_item), notice: "Inventory item created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize [ :inventory, @inventory_item ]
  end

  def update
    authorize [ :inventory, @inventory_item ]

    if @inventory_item.update(inventory_item_params)
      redirect_to inventory_inventory_item_path(@inventory_item), notice: "Inventory item updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize [ :inventory, @inventory_item ]
    @inventory_item.destroy
    redirect_to inventory_inventory_items_path, notice: "Inventory item removed."
  end

  private

  def set_inventory_item
    @inventory_item = policy_scope([ :inventory, InventoryItem ]).find(params[:id])
  end

  def inventory_item_params
    params.require(:inventory_item).permit(
      :sku, :name, :unit, :unit_cost, :reorder_threshold, :description,
      project_ids: []
    )
  end
end
