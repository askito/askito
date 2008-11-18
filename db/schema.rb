# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081118034302) do

  create_table "answer_dates", :force => true do |t|
    t.integer  "respondent_id"
    t.integer  "question_id"
    t.datetime "value"
  end

  add_index "answer_dates", ["question_id"], :name => "index_answer_dates_on_question_id"
  add_index "answer_dates", ["respondent_id"], :name => "index_answer_dates_on_respondent_id"

  create_table "answer_texts", :force => true do |t|
    t.integer "respondent_id"
    t.integer "question_id"
    t.text    "value"
  end

  add_index "answer_texts", ["question_id"], :name => "index_answer_texts_on_question_id"
  add_index "answer_texts", ["respondent_id"], :name => "index_answer_texts_on_respondent_id"

  create_table "answers", :force => true do |t|
    t.integer "respondent_id"
    t.integer "question_id"
    t.integer "option_id"
    t.integer "row_id"
    t.integer "col_id"
  end

  add_index "answers", ["option_id"], :name => "index_answers_on_option_id"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["respondent_id"], :name => "index_answers_on_respondent_id"

  create_table "contents", :force => true do |t|
    t.integer  "questionnaire_id"
    t.string   "type",             :limit => 50
    t.string   "template",         :limit => 50
    t.integer  "position",                       :default => 1
    t.text     "text"
    t.text     "settings"
    t.string   "hint"
    t.string   "code"
    t.boolean  "requires_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["questionnaire_id"], :name => "index_contents_on_questionnaire_id"

  create_table "options", :force => true do |t|
    t.integer  "question_id"
    t.string   "label"
    t.string   "option_type"
    t.integer  "value"
    t.integer  "position",      :default => 1
    t.integer  "answers_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "options", ["question_id"], :name => "index_options_on_question_id"

  create_table "questionnaires", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "title"
    t.string   "caption"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questionnaires", ["title"], :name => "index_questionnaires_on_title"
  add_index "questionnaires", ["user_id"], :name => "index_questionnaires_on_user_id"

  create_table "respondents", :force => true do |t|
    t.integer  "questionnaire_id"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "started_at"
    t.datetime "completed_at"
  end

  add_index "respondents", ["completed_at"], :name => "index_respondents_on_completed_at"
  add_index "respondents", ["questionnaire_id"], :name => "index_respondents_on_questionnaire_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.boolean  "administrator"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
