# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171209042914) do

  create_table "announcements", force: :cascade do |t|
    t.string "name"
    t.datetime "announcement_date"
    t.string "announcement_body"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assignments", force: :cascade do |t|
    t.string "name"
    t.datetime "due_date"
    t.string "instructions"
    t.string "template"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lang"
    t.string "test_code"
    t.string "pdf_instruction_file_name"
    t.string "pdf_instruction_content_type"
    t.integer "pdf_instruction_file_size"
    t.datetime "pdf_instruction_updated_at"
    t.integer "num_unit_tests"
  end

  create_table "codes", force: :cascade do |t|
    t.string "source_code"
    t.string "filename"
    t.integer "submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_title"
    t.string "course_code"
    t.string "permission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", force: :cascade do |t|
    t.float "grade"
    t.integer "course_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "total"
    t.float "count"
  end

  create_table "submissions", force: :cascade do |t|
    t.boolean "submitted"
    t.datetime "submission_date"
    t.string "source_code"
    t.float "grade"
    t.string "comments"
    t.integer "user_id"
    t.integer "assignment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "auto_grade"
  end

  create_table "tests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "assignment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "oauth_provider"
    t.string "oauth_uid"
    t.string "oauth_name"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.string "profile_pic"
    t.string "phone"
  end

end
