class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]
  include Pundit::Authorization

  def index
    @projects = policy_scope(Project)
  end

  def show
    authorize @project
  end

  def new
    @project = Project.new
    @project.project_files.build
    authorize @project
  end

  def edit
    authorize @project
    @project.project_files.build if @project.project_files.empty?
  end

  def create
    @project = current_user.projects.build(project_params)
    authorize @project

    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @project
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @project
    @project.destroy!
    redirect_to projects_path, notice: "Project was successfully destroyed.", status: :see_other
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name, :description, :status, :deadline, :budget, :progress,
      project_files_attributes: [ :id, :title, :description, :file, :_destroy ]
    )
  end
end
