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

ActiveRecord::Schema[8.0].define(version: 2025_12_30_164827) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "task_id" ], name: "index_assignments_on_task_id"
    t.index [ "user_id" ], name: "index_assignments_on_user_id"
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

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "deadline"
    t.decimal "budget", precision: 12, scale: 2
    t.integer "progress", default: 0, null: false
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
    t.bigint "project_id", null: false
    t.date "date", null: false
    t.string "description", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.integer "transaction_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "reference"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "project_id", "date" ], name: "index_transactions_on_project_id_and_date"
    t.index [ "project_id" ], name: "index_transactions_on_project_id"
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
    t.index [ "email" ], name: "index_users_on_email", unique: true
    t.index [ "reset_password_token" ], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assignments", "tasks"
  add_foreign_key "assignments", "users"
  add_foreign_key "hr_employees", "hr_employees", column: "manager_id"
  add_foreign_key "hr_employees", "users"
  add_foreign_key "hr_leaves", "hr_employees", column: "employee_id"
  add_foreign_key "hr_leaves", "hr_employees", column: "manager_id"
  add_foreign_key "projects", "users"
  add_foreign_key "reports", "projects"
  add_foreign_key "reports", "users"
  add_foreign_key "tasks", "projects"
  add_foreign_key "transactions", "projects"
end
