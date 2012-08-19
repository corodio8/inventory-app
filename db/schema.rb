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

ActiveRecord::Schema.define(:version => 20120816042609) do

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "computer_id"
    t.date     "assign_date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "computers", :force => true do |t|
    t.string   "serial_no"
    t.integer  "asset_tag"
    t.string   "computer_name"
    t.string   "make"
    t.string   "model"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "uname"
    t.string   "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
