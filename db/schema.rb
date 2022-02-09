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

ActiveRecord::Schema.define(version: 2021_04_27_142548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "path", null: false
    t.string "content_base64", null: false
    t.date "deadline_at", null: false
    t.boolean "auto_close", default: true, null: false
    t.boolean "sequence_enabled", default: false, null: false
    t.integer "remind_interval", default: 3, null: false
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "integrations_webhook_state_transitions", force: :cascade do |t|
    t.bigint "webhook_id", null: false
    t.string "to_state", null: false
    t.jsonb "metadata", default: {}
    t.integer "sort_key", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["webhook_id", "most_recent"], name: "index_webhook_state_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["webhook_id", "sort_key"], name: "index_webhook_state_transitions_parent_sort", unique: true
    t.index ["webhook_id"], name: "index_integrations_webhook_state_transitions_on_webhook_id"
  end

  create_table "integrations_webhooks", force: :cascade do |t|
    t.string "provider", null: false
    t.jsonb "body", default: {}
    t.jsonb "headers", default: {}
    t.string "state", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "integrations_webhook_state_transitions", "integrations_webhooks", column: "webhook_id", on_delete: :cascade
end
