class ProjectExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[new create]
  before_action :set_expense, only: %i[show edit update destroy]

  def index
    @expenses = policy_scope(ProjectExpense).includes(:project).order(date: :desc)
    authorize ProjectExpense
  end

  def show
    authorize @expense
  end

  def new
    if @project
      @expense = @project.project_expenses.build(date: Date.current)
    else
      @expense = ProjectExpense.new(date: Date.current)
    end
    authorize @expense
  end

  def create
    if @project
      @expense = @project.project_expenses.build(expense_params)
    else
      @expense = ProjectExpense.new(expense_params)
    end
    authorize @expense

    if @expense.save
      if @project
        redirect_to project_path(@project), notice: "Expense recorded."
      else
        redirect_to project_expenses_path, notice: "Expense recorded."
      end
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @expense
  end

  def update
    authorize @expense
    if @expense.update(expense_params)
      if @expense.project
        redirect_to project_path(@expense.project), notice: "Expense updated."
      else
        redirect_to project_expenses_path, notice: "Expense updated."
      end
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @expense
    project = @expense.project
    @expense.destroy
    if project
      redirect_to project_path(project), notice: "Expense deleted."
    else
      redirect_to project_expenses_path, notice: "Expense deleted."
    end
  end

  private

  def set_project
    @project = Project.find_by(id: params[:project_id])
  end

  def set_expense
    @expense = ProjectExpense.find(params[:id])
  end

  def expense_params
    params.require(:project_expense).permit(:date, :description, :amount, :reference, :notes, :project_id)
  end
end
