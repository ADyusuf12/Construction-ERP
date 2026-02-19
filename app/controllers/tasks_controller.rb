# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [ :index, :new, :create, :my_tasks ]
  before_action :set_task, only: %i[ show edit update destroy in_progress complete ]

  def index
    @tasks = policy_scope(Task.includes(:project, employees: :personal_detail))
  end

  # NEW: Focused view for the logged-in employee
  def my_tasks
    # Grouping by project makes it much easier for field staff to navigate
    @tasks_by_project = TaskPolicy::Scope.new(current_user, Task)
                        .assigned_only
                        .includes(:project)
                        .where.not(status: :done)
                        .group_by(&:project)

    render :my_tasks
  end

  def show
    authorize @task
  end

  def new
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @task = @project.tasks.build
    else
      @task = Task.new
    end
    authorize @task
  end

  def create
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @task = @project.tasks.build(task_params)
    else
      @task = Task.new(task_params)
    end
    authorize @task

    if @task.save
      redirect_to [ @task.project, @task ], notice: "Task was successfully deployed."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @task
    if @task.update(task_params)
      redirect_to [ @project, @task ], notice: "Task parameters updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @task
    @task.destroy
    redirect_to project_tasks_path(@project), notice: "Task successfully decommissioned."
  end

  def in_progress
    authorize @task, :mark_in_progress?
    if @task.update(status: :in_progress)
      render_task_update("Task transition: In Progress.")
    else
      render_task_update("Transition failed: Validation constraint.", :alert)
    end
  end

  def complete
    authorize @task, :mark_done?
    if @task.update(status: :done)
      render_task_update("Task finalized and logged.")
    else
      render_task_update("Transition failed: Validation constraint.", :alert)
    end
  end

  private

  def render_task_update(message, type = :notice)
    respond_to do |format|
      format.html { redirect_to project_tasks_path(@project), type => message }
      format.turbo_stream do
        flash.now[type] = message
        render "tasks/update"
      end
    end
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :details, :status, :due_date, :weight, :project_id, employee_ids: [])
  end
end
