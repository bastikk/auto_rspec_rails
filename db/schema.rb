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

ActiveRecord::Schema[7.0].define(version: 2023_05_12_231151) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
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
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.string "some"
    t.integer "status"
    t.string "status2"
    t.string "readonly_text"
    t.index ["a_id"], name: "index_test_models_on_a_id", unique: true
    t.index ["as_id"], name: "index_test_models_on_as_id"
    t.index ["b_id"], name: "index_test_models_on_b_id"
    t.index ["bs_id"], name: "index_test_models_on_bs_id"
    t.index ["cs_id"], name: "index_test_models_on_cs_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "as", "test_models"
  add_foreign_key "bs", "test_models", column: "test_models_id"
  add_foreign_key "cs", "test_models", column: "test_models_id"
  add_foreign_key "test_models", "as", column: "as_id"
  add_foreign_key "test_models", "bs", column: "bs_id"
  add_foreign_key "test_models", "cs", column: "cs_id"
end
