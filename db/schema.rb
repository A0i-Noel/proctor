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

ActiveRecord::Schema[7.0].define(version: 2025_10_24_224052) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "question_role_targets", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id", "role_id"], name: "index_question_role_targets_on_question_id_and_role_id", unique: true
    t.index ["question_id"], name: "index_question_role_targets_on_question_id"
    t.index ["role_id"], name: "index_question_role_targets_on_role_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.text "content"
    t.string "question_type"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "options"
    t.boolean "required"
    t.string "target_role_ids", default: [], null: false, array: true
    t.index ["survey_id"], name: "index_questions_on_survey_id"
    t.index ["target_role_ids"], name: "index_questions_on_target_role_ids", using: :gin
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.bigint "question_id", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id", null: false
    t.bigint "submission_id"
    t.index ["question_id"], name: "index_responses_on_question_id"
    t.index ["role_id"], name: "index_responses_on_role_id"
    t.index ["submission_id"], name: "index_responses_on_submission_id"
    t.index ["survey_id"], name: "index_responses_on_survey_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "role"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.bigint "role_id", null: false
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_submissions_on_role_id"
    t.index ["survey_id"], name: "index_submissions_on_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "question_role_targets", "questions"
  add_foreign_key "question_role_targets", "roles"
  add_foreign_key "questions", "surveys"
  add_foreign_key "responses", "questions"
  add_foreign_key "responses", "roles"
  add_foreign_key "responses", "submissions"
  add_foreign_key "responses", "surveys"
  add_foreign_key "submissions", "roles"
  add_foreign_key "submissions", "surveys"
end
