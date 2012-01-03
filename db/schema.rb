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

ActiveRecord::Schema.define(:version => 20120103154923) do

  create_table "comments", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dogs", :force => true do |t|
    t.string   "akc_id"
    t.string   "owner"
    t.string   "akc_name"
    t.string   "breed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dogs", ["akc_id"], :name => "index_dogs_on_akc_id", :unique => true

  create_table "judges", :force => true do |t|
    t.integer  "judge_id"
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "judges", ["judge_id"], :name => "index_judges_on_judge_id", :unique => true

  create_table "obedclasses", :force => true do |t|
    t.integer "judge_id"
    t.integer "show_id"
    t.string  "classname"
    t.integer "dogs_in_class"
  end

  create_table "obedscores", :force => true do |t|
    t.integer "show_id"
    t.integer "dog_id",    :limit => 255
    t.string  "classname"
    t.float   "score"
    t.integer "placement"
    t.string  "award"
    t.string  "dog_name"
  end

  add_index "obedscores", ["dog_id"], :name => "index_obedscores_on_dog_id"
  add_index "obedscores", ["show_id"], :name => "index_obedscores_on_show_id"

  create_table "ralclasses", :force => true do |t|
    t.integer "judge_id"
    t.integer "ralshow_id"
    t.string  "classname"
    t.integer "dogs_in_class"
  end

  create_table "ralscores", :force => true do |t|
    t.integer "ralshow_id"
    t.integer "dog_id"
    t.string  "classname"
    t.float   "score"
    t.integer "placement"
    t.string  "award"
    t.string  "dog_name"
    t.integer "classorder"
  end

  add_index "ralscores", ["dog_id"], :name => "index_ralscores_on_dog_id"
  add_index "ralscores", ["ralshow_id"], :name => "index_ralscores_on_ralshow_id"

  create_table "ralshows", :force => true do |t|
    t.integer  "show_id"
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ralshows", ["show_id"], :name => "index_ralshows_on_show_id", :unique => true

  create_table "shows", :force => true do |t|
    t.integer  "show_id"
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shows", ["show_id"], :name => "index_shows_on_show_id", :unique => true

end
