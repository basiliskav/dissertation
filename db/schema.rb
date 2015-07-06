# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150705225651) do

  create_table "archives", force: true do |t|
    t.string   "name"
    t.text     "text"
    t.integer  "user_id"
    t.integer  "folder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "archives", ["folder_id"], name: "index_archives_on_folder_id"
  add_index "archives", ["user_id"], name: "index_archives_on_user_id"

  create_table "folders", force: true do |t|
    t.string   "name",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  add_index "folders", ["parent_id"], name: "index_folders_on_parent_id"
  add_index "folders", ["user_id"], name: "index_folders_on_user_id"

  create_table "rm_repo_items", force: true do |t|
    t.integer "owner_id"
    t.string  "owner_type"
    t.integer "sender_id"
    t.string  "sender_type"
    t.string  "ancestry"
    t.integer "ancestry_depth", default: 0
    t.string  "name"
    t.float   "file_size"
    t.string  "content_type"
    t.string  "file"
    t.string  "type"
  end

  add_index "rm_repo_items", ["owner_id", "owner_type"], name: "index_rm_repo_items_on_owner_id_and_owner_type"
  add_index "rm_repo_items", ["sender_id", "sender_type"], name: "index_rm_repo_items_on_sender_id_and_sender_type"

  create_table "rm_sharings", force: true do |t|
    t.integer "owner_id"
    t.string  "owner_type"
    t.integer "creator_id"
    t.string  "creator_type"
    t.integer "repo_item_id"
    t.boolean "can_create",   default: false
    t.boolean "can_read",     default: false
    t.boolean "can_update",   default: false
    t.boolean "can_delete",   default: false
    t.boolean "can_share",    default: false
  end

  add_index "rm_sharings", ["creator_id", "creator_type"], name: "index_rm_sharings_on_creator_id_and_creator_type"
  add_index "rm_sharings", ["owner_id", "owner_type"], name: "index_rm_sharings_on_owner_id_and_owner_type"
  add_index "rm_sharings", ["repo_item_id"], name: "index_rm_sharings_on_repo_item_id"

  create_table "rm_sharings_members", force: true do |t|
    t.integer "sharing_id"
    t.integer "member_id"
    t.string  "member_type"
    t.boolean "can_add",     default: false
    t.boolean "can_remove",  default: false
  end

  add_index "rm_sharings_members", ["member_id", "member_type"], name: "index_rm_sharings_members_on_member_id_and_member_type"
  add_index "rm_sharings_members", ["sharing_id"], name: "index_rm_sharings_members_on_sharing_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",               default: "",    null: false
    t.string   "unconfirmed_email"
    t.string   "confirmation_token"
    t.string   "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "is_active",              default: true,  null: false
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
