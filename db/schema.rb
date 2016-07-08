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

ActiveRecord::Schema.define(:version => 20160708182309) do

  create_table "admins", :force => true do |t|
    t.string   "displayName"
    t.string   "netid"
    t.string   "duid"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "remote_jobs", :force => true do |t|
    t.string   "model"
    t.string   "output_unit"
    t.string   "epsilon"
    t.boolean  "submitted"
    t.boolean  "completeted"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "uploadfile"
    t.string   "opaque_id"
    t.string   "job_submit_token"
  end

  create_table "sessions", :force => true do |t|
    t.string   "netid"
    t.string   "action"
    t.string   "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shiny_dockers", :force => true do |t|
    t.text     "host"
    t.integer  "port"
    t.string   "pw"
    t.string   "appname"
    t.text     "appdesc"
    t.boolean  "expired"
    t.string   "netid"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "job_submit_token"
  end

  create_table "users", :force => true do |t|
    t.string   "displayName"
    t.string   "netid"
    t.string   "duid"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
