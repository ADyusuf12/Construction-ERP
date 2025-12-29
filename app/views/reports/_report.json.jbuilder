json.extract! report, :id, :project_id, :user_id, :report_date, :report_type, :status, :progress_summary, :issues, :next_steps, :created_at, :updated_at
json.url report_url(report, format: :json)
