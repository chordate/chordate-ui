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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130110232610) do

  create_table "accounts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "application_users", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "application_id", :null => false
    t.integer  "user_id",        :null => false
  end

  add_index "application_users", ["application_id", "user_id"], :name => "index_application_users_on_application_id_and_user_id", :unique => true

  create_table "applications", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "account_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "token"
  end

  create_table "events", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "generated_at"
    t.integer  "account_id"
    t.integer  "application_id"
    t.string   "env"
    t.string   "klass"
    t.string   "message"
    t.string   "source"
    t.string   "action"
    t.string   "model_type"
    t.string   "model_id"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.integer  "salt"
    t.string   "token"
    t.integer  "account_id"
  end

end
