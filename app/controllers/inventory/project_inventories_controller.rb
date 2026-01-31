# app/controllers/inventory/project_inventories_controller.rb
module Inventory
  class ProjectInventoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_project, only: %i[create]
    before_action :set_project_inventory, only: %i[edit update destroy]

    def create
      @project_inventory = @project.project_inventories.find_or_initialize_by(inventory_item_id: project_inventory_params[:inventory_item_id])
      @project_inventory.assign_attributes(project_inventory_params)
      authorize [ :inventory, @project_inventory ]

      if @project_inventory.save
        redirect_back fallback_location: project_path(@project), notice: "Reserved items for project."
      else
        redirect_back fallback_location: project_path(@project), alert: @project_inventory.errors.full_messages.to_sentence
      end
    end

    def edit
      authorize [ :inventory, @project_inventory ]
    end

    def update
      @project_inventory = ProjectInventory.find(params[:id])
      authorize [ :inventory, @project_inventory ]

      if @project_inventory.update(project_inventory_params)
        @project ||= @project_inventory.project
        redirect_back fallback_location: project_path(@project), notice: "Reservation updated."
      else
        @project ||= @project_inventory.project
        redirect_back fallback_location: project_path(@project), alert: @project_inventory.errors.full_messages.to_sentence
      end
    end

    def destroy
      @project_inventory = ProjectInventory.find(params[:id])
      authorize [ :inventory, @project_inventory ]
      @project_inventory.destroy
      @project ||= @project_inventory.project
      redirect_back fallback_location: project_path(@project), notice: "Reservation removed."
    end

    private

    def set_project
      @project = Project.find(params[:project_id] || params.dig(:project_inventory, :project_id))
    end

    def set_project_inventory
      @project_inventory = ProjectInventory.find(params[:id])
    end

    def project_inventory_params
      params.require(:project_inventory).permit(:inventory_item_id, :quantity_reserved, :task_id)
    end
  end
end
