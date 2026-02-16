class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [ :index, :new, :create ]
  before_action :set_report, only: %i[ show edit update destroy submit review ]
  include Pundit::Authorization

  def index
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @reports = policy_scope(@project.reports)
    else
      @reports = policy_scope(Report.includes(:project, :employee))
    end
  end

  def show
    authorize @report
  end

  def new
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @report = @project.reports.build
    else
      @report = Report.new
    end
    authorize @report
  end

  def edit
    authorize @report
  end

  def create
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @report = @project.reports.build(report_params)
    else
      @report = Report.new(report_params)
      @report.project = Project.find(report_params[:project_id])
    end
    @report.employee = current_user.employee
    authorize @report

    if @report.save
      redirect_to [ @report.project, @report ], notice: "Operational report filed."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @report
    if @report.update(report_params)
      redirect_to [ @project, @report ], notice: "Report updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @report
    @report.destroy
    redirect_to project_reports_path(@project), notice: "Report deleted.", status: :see_other
  end

  def submit
    authorize @report, :submit?
    if @report.status_draft? && @report.update(status: :submitted)
      render_report_update("Report transmitted for review.")
    else
      render_report_update("Action denied: Report must be in draft status.", :alert)
    end
  end

  def review
    authorize @report, :review?
    if @report.status_submitted? && @report.update(status: :reviewed)
      render_report_update("Report reviewed and finalized.")
    else
      render_report_update("Action denied: Report must be in submitted status.", :alert)
    end
  end

  private

  def render_report_update(message, type = :notice)
    respond_to do |format|
      format.html { redirect_to [ @project, @report ], type => message }
      format.turbo_stream do
        flash.now[type] = message
        render "reports/update"
      end
    end
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_report
    @report = @project.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:project_id, :report_date, :report_type, :status, :progress_summary, :issues, :next_steps)
  end
end
