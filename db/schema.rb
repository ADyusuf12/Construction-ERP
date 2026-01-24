# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_01_22_165430) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounting_deductions", force: :cascade do |t|
    t.bigint "salary_id", null: false
    t.integer "deduction_type", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "salary_id" ], name: "index_accounting_deductions_on_salary_id"
  end

  create_table "accounting_salaries", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "batch_id", null: false
    t.decimal "base_pay", precision: 12, scale: 2, null: false
    t.decimal "allowances", precision: 12, scale: 2, default: "0.0"
    t.decimal "deductions_total", precision: 12, scale: 2, default: "0.0"
    t.decimal "net_pay", precision: 12, scale: 2, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "batch_id" ], name: "index_accounting_salaries_on_batch_id"
    t.index [ "employee_id" ], name: "index_accounting_salaries_on_employee_id"
  end

  create_table "accounting_salary_batches", force: :cascade do |t|
    t.string "name"
    t.date "period_start"
    t.date "period_end"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index [ "blob_id" ], name: "index_active_storage_attachments_on_blob_id"
    t.index [ "record_type", "record_id", "name", "blob_id" ], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index [ "key" ], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index [ "blob_id", "variation_digest" ], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "task_id" ], name: "index_assignments_on_task_id"
    t.index [ "user_id" ], name: "index_assignments_on_user_id"
  end

  create_table "business_clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "company"
    t.string "email"
    t.string "phone"
    t.text "address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index [ "email" ], name: "index_business_clients_on_email", unique: true
    t.index [ "name" ], name: "index_business_clients_on_name"
    t.index [ "user_id" ], name: "index_business_clients_on_user_id"
  end

  create_table "hr_employees", force: :cascade do |t|
    t.string "hamzis_id", null: false
    t.string "department"
    t.string "position_title"
    t.date "hire_date"
    t.integer "status", default: 0
    t.integer "leave_balance", default: 0
    t.decimal "performance_score", precision: 5, scale: 2
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "manager_id"
    t.index [ "hamzis_id" ], name: "index_hr_employees_on_hamzis_id", unique: true
    t.index [ "manager_id" ], name: "index_hr_employees_on_manager_id"
    t.index [ "user_id" ], name: "index_hr_employees_on_user_id"
  end

  create_table "hr_leaves", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "manager_id"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.text "reason", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "employee_id" ], name: "index_hr_leaves_on_employee_id"
    t.index [ "manager_id" ], name: "index_hr_leaves_on_manager_id"
  end

  create_table "hr_personal_details", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.integer "gender"
    t.string "bank_name"
    t.string "account_number"
    t.string "account_name"
    t.integer "means_of_identification"
    t.string "id_number"
    t.integer "marital_status"
    t.text "address"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "employee_id" ], name: "index_hr_personal_details_on_employee_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.string "sku", null: false
    t.string "name", null: false
    t.text "description"
    t.decimal "unit_cost", precision: 12, scale: 2, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.integer "reorder_threshold", default: 5, null: false
    t.string "default_location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit", default: "pcs", null: false
    t.index [ "created_at" ], name: "index_inventory_items_on_created_at"
    t.index [ "sku" ], name: "index_inventory_items_on_sku", unique: true
    t.index [ "status" ], name: "index_inventory_items_on_status"
    t.index [ "unit" ], name: "index_inventory_items_on_unit"
  end

  create_table "project_expenses", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.date "date", null: false
    t.string "description", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.string "reference"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "project_id" ], name: "index_project_expenses_on_project_id"
  end

  create_table "project_files", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index [ "project_id" ], name: "index_project_files_on_project_id"
  end

  create_table "project_inventories", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "inventory_item_id", null: false
    t.integer "quantity", default: 0, null: false
    t.string "purpose"
    t.bigint "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "inventory_item_id" ], name: "index_project_inventories_on_inventory_item_id"
    t.index [ "project_id", "inventory_item_id" ], name: "index_project_inventories_on_project_and_item", unique: true
    t.index [ "project_id" ], name: "index_project_inventories_on_project_id"
    t.index [ "task_id" ], name: "index_project_inventories_on_task_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "deadline"
    t.decimal "budget", precision: 12, scale: 2
    t.bigint "client_id"
    t.index [ "client_id" ], name: "index_projects_on_client_id"
    t.index [ "user_id" ], name: "index_projects_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.date "report_date", null: false
    t.integer "report_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.text "progress_summary"
    t.text "issues"
    t.text "next_steps"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "project_id" ], name: "index_reports_on_project_id"
    t.index [ "user_id" ], name: "index_reports_on_user_id"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index [ "concurrency_key", "priority", "job_id" ], name: "index_solid_queue_blocked_executions_for_release"
    t.index [ "expires_at", "concurrency_key" ], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index [ "job_id" ], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index [ "job_id" ], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index [ "process_id", "job_id" ], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index [ "job_id" ], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "active_job_id" ], name: "index_solid_queue_jobs_on_active_job_id"
    t.index [ "class_name" ], name: "index_solid_queue_jobs_on_class_name"
    t.index [ "finished_at" ], name: "index_solid_queue_jobs_on_finished_at"
    t.index [ "queue_name", "finished_at" ], name: "index_solid_queue_jobs_for_filtering"
    t.index [ "scheduled_at", "finished_at" ], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index [ "queue_name" ], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.index [ "last_heartbeat_at" ], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index [ "name", "supervisor_id" ], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index [ "supervisor_id" ], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index [ "job_id" ], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index [ "priority", "job_id" ], name: "index_solid_queue_poll_all"
    t.index [ "queue_name", "priority", "job_id" ], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index [ "job_id" ], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index [ "task_key", "run_at" ], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "key" ], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index [ "static" ], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index [ "job_id" ], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index [ "scheduled_at", "priority", "job_id" ], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "expires_at" ], name: "index_solid_queue_semaphores_on_expires_at"
    t.index [ "key", "value" ], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index [ "key" ], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "stock_levels", force: :cascade do |t|
    t.bigint "inventory_item_id", null: false
    t.bigint "warehouse_id", null: false
    t.integer "quantity", default: 0, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "inventory_item_id", "warehouse_id" ], name: "index_stock_levels_on_item_and_warehouse", unique: true
    t.index [ "inventory_item_id" ], name: "index_stock_levels_on_inventory_item_id"
    t.index [ "warehouse_id" ], name: "index_stock_levels_on_warehouse_id"
  end

  create_table "stock_movements", force: :cascade do |t|
    t.bigint "inventory_item_id", null: false
    t.bigint "warehouse_id", null: false
    t.integer "movement_type", default: 0, null: false
    t.integer "quantity", null: false
    t.decimal "unit_cost", precision: 12, scale: 2
    t.string "reference"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id"
    t.datetime "applied_at"
    t.bigint "project_id"
    t.bigint "task_id"
    t.index [ "applied_at" ], name: "index_stock_movements_on_applied_at"
    t.index [ "created_at" ], name: "index_stock_movements_on_created_at"
    t.index [ "employee_id" ], name: "index_stock_movements_on_employee_id"
    t.index [ "inventory_item_id", "created_at" ], name: "index_stock_movements_on_item_and_created_at"
    t.index [ "inventory_item_id" ], name: "index_stock_movements_on_inventory_item_id"
    t.index [ "movement_type" ], name: "index_stock_movements_on_movement_type"
    t.index [ "project_id" ], name: "index_stock_movements_on_project_id"
    t.index [ "task_id" ], name: "index_stock_movements_on_task_id"
    t.index [ "warehouse_id" ], name: "index_stock_movements_on_warehouse_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", null: false
    t.text "details"
    t.integer "status", default: 0, null: false
    t.datetime "due_date"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 1, null: false
    t.index [ "project_id" ], name: "index_tasks_on_project_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.date "date", null: false
    t.string "description", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.integer "transaction_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "reference"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "status" ], name: "index_transactions_on_status"
    t.index [ "transaction_type" ], name: "index_transactions_on_transaction_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.bigint "client_id"
    t.index [ "client_id" ], name: "index_users_on_client_id"
    t.index [ "email" ], name: "index_users_on_email", unique: true
    t.index [ "reset_password_token" ], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "code" ], name: "index_warehouses_on_code", unique: true
    t.index [ "name" ], name: "index_warehouses_on_name"
  end

  add_foreign_key "accounting_deductions", "accounting_salaries", column: "salary_id"
  add_foreign_key "accounting_salaries", "accounting_salary_batches", column: "batch_id"
  add_foreign_key "accounting_salaries", "hr_employees", column: "employee_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assignments", "tasks"
  add_foreign_key "assignments", "users"
  add_foreign_key "business_clients", "users"
  add_foreign_key "hr_employees", "hr_employees", column: "manager_id"
  add_foreign_key "hr_employees", "users"
  add_foreign_key "hr_leaves", "hr_employees", column: "employee_id"
  add_foreign_key "hr_leaves", "hr_employees", column: "manager_id"
  add_foreign_key "hr_personal_details", "hr_employees", column: "employee_id"
  add_foreign_key "project_expenses", "projects"
  add_foreign_key "project_files", "projects"
  add_foreign_key "project_inventories", "inventory_items"
  add_foreign_key "project_inventories", "projects"
  add_foreign_key "project_inventories", "tasks"
  add_foreign_key "projects", "business_clients", column: "client_id"
  add_foreign_key "projects", "users"
  add_foreign_key "reports", "projects"
  add_foreign_key "reports", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "stock_levels", "inventory_items"
  add_foreign_key "stock_levels", "warehouses"
  add_foreign_key "stock_movements", "hr_employees", column: "employee_id"
  add_foreign_key "stock_movements", "inventory_items"
  add_foreign_key "stock_movements", "projects"
  add_foreign_key "stock_movements", "tasks"
  add_foreign_key "stock_movements", "warehouses"
  add_foreign_key "tasks", "projects"
  add_foreign_key "users", "business_clients", column: "client_id"
end
