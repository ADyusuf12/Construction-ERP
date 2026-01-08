class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [ :index, :new, :create ]
  before_action :set_task, only: %i[ show edit update destroy in_progress complete ]

  # GET /tasks (global index)
  def index
    @tasks = policy_scope(Task.includes(:project, users: { employee: :personal_detail }))
  end

  # GET /projects/:project_id/tasks/:id
  def show
    authorize @task
  end

  # GET /projects/:project_id/tasks/new OR /tasks/new
  def new
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @task = @project.tasks.build
    else
      @task = Task.new
    end
    authorize @task
  end

  # POST /projects/:project_id/tasks OR /tasks
  def create
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @task = @project.tasks.build(task_params)
    else
      @task = Task.new(task_params)
    end
    authorize @task

    if @task.save
      redirect_to [ @task.project, @task ], notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/:project_id/tasks/:id
  def update
    authorize @task
    if @task.update(task_params)
      redirect_to [ @project, @task ], notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/:project_id/tasks/:id
  def destroy
    authorize @task
    @task.destroy
    redirect_to project_tasks_path(@project), notice: "Task was successfully deleted."
  end

  def in_progress
    authorize @task, :mark_in_progress?
    if @task.update(status: :in_progress)
      respond_to do |format|
        format.turbo_stream { render partial: "tasks/update_row" }
        format.html { redirect_to project_tasks_path(@project), notice: "Task marked as in progress." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render partial: "tasks/update_row" }
        format.html { redirect_to project_tasks_path(@project), alert: "Failed to mark task as in progress." }
      end
    end
  end

  def complete
    authorize @task, :mark_done?
    if @task.update(status: :done)
      respond_to do |format|
        format.turbo_stream { render partial: "tasks/update_row" }
        format.html { redirect_to project_tasks_path(@project), notice: "Task marked as complete." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render partial: "tasks/update_row" }
        format.html { redirect_to project_tasks_path(@project), alert: "Failed to mark task as complete." }
      end
    end
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_task
      @task = @project.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :details, :status, :due_date, :weight, :project_id, user_ids: [])
    end
end
