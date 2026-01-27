class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [ :index, :new, :create ]
  before_action :set_report, only: %i[ show edit update destroy submit review ]
  include Pundit::Authorization

  # GET /reports (global index) OR /projects/:project_id/reports (scoped index)
  def index
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @reports = policy_scope(@project.reports)
    else
      @reports = policy_scope(Report.includes(:project, :user))
    end
  end

  # GET /projects/:project_id/reports/:id
  def show
    authorize @report
  end

  # GET /projects/:project_id/reports/new OR /reports/new
  def new
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @report = @project.reports.build
    else
      @report = Report.new
    end
    authorize @report
  end

  # GET /projects/:project_id/reports/:id/edit
  def edit
    authorize @report
  end

  # POST /projects/:project_id/reports OR /reports
  def create
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @report = @project.reports.build(report_params)
    else
      @report = Report.new(report_params)
      @report.project = Project.find(report_params[:project_id])
    end
    @report.user = current_user
    authorize @report

    if @report.save
      redirect_to [ @report.project, @report ], notice: "Report was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /projects/:project_id/reports/:id
  def update
    authorize @report
    if @report.update(report_params)
      redirect_to [ @project, @report ], notice: "Report was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /projects/:project_id/reports/:id
  def destroy
    authorize @report
    @report.destroy
    redirect_to project_reports_path(@project), notice: "Report was successfully deleted.", status: :see_other
  end

  # PATCH /projects/:project_id/reports/:id/submit
  def submit
    authorize @report, :submit?
    if @report.status_draft?
      @report.update(status: :submitted)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to [ @project, @report ], notice: "Report was successfully submitted." }
      end
    else
      redirect_to [ @project, @report ], alert: "Report cannot be submitted."
    end
  end

  # PATCH /projects/:project_id/reports/:id/review
  def review
    authorize @report, :review?
    if @report.status_submitted?
      @report.update(status: :reviewed)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to [ @project, @report ], notice: "Report was successfully reviewed." }
      end
    else
      redirect_to [ @project, @report ], alert: "Report cannot be reviewed."
    end
  end

  private

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
