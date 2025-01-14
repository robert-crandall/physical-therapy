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

ActiveRecord::Schema[8.0].define(version: 2025_01_14_010623) do
  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "order"
    t.boolean "enabled"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exercise_histories", force: :cascade do |t|
    t.integer "exercise_id", null: false
    t.integer "sets"
    t.integer "reps"
    t.integer "weight"
    t.boolean "success"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sequence_position", default: 0, null: false
    t.index ["exercise_id"], name: "index_exercise_histories_on_exercise_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "link"
    t.integer "category_id", null: false
    t.integer "lift_scheme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight"
    t.integer "progression"
    t.index ["category_id"], name: "index_exercises_on_category_id"
  end

  add_foreign_key "exercise_histories", "exercises"
  add_foreign_key "exercises", "categories"
end
