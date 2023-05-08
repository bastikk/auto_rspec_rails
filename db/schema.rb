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

ActiveRecord::Schema[7.0].define(version: 2023_05_08_232037) do
  create_table "as", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "test_model_id", null: false
    t.index ["test_model_id"], name: "index_as_on_test_model_id"
  end

  create_table "bs", force: :cascade do |t|
    t.string "title1"
    t.text "body1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "test_models_id", null: false
    t.index ["test_models_id"], name: "index_bs_on_test_models_id"
  end

  create_table "cs", force: :cascade do |t|
    t.string "title2"
    t.text "body2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "test_models_id", null: false
    t.integer "test_model_id"
    t.index ["test_model_id"], name: "index_cs_on_test_model_id"
    t.index ["test_models_id"], name: "index_cs_on_test_models_id"
  end

  create_table "ds", force: :cascade do |t|
    t.string "title3"
    t.text "body3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_models", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cs_id", null: false
    t.integer "as_id", null: false
    t.integer "bs_id", null: false
    t.integer "a_id"
    t.integer "b_id"
    t.index ["a_id"], name: "index_test_models_on_a_id"
    t.index ["as_id"], name: "index_test_models_on_as_id"
    t.index ["b_id"], name: "index_test_models_on_b_id"
    t.index ["bs_id"], name: "index_test_models_on_bs_id"
    t.index ["cs_id"], name: "index_test_models_on_cs_id"
  end

  add_foreign_key "as", "test_models"
  add_foreign_key "bs", "test_models", column: "test_models_id"
  add_foreign_key "cs", "test_models", column: "test_models_id"
  add_foreign_key "test_models", "as", column: "as_id"
  add_foreign_key "test_models", "bs", column: "bs_id"
  add_foreign_key "test_models", "cs", column: "cs_id"
end
