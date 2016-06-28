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

ActiveRecord::Schema.define(version: 20160512083605) do

  create_table "action_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.boolean  "announcement_action"
    t.integer  "display_order"
  end

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "activities", force: true do |t|
    t.integer  "property_id"
    t.integer  "email_notification_id"
    t.integer  "note_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sms_property_id"
    t.integer  "property_call_id"
  end

  create_table "add_on_statuses", force: true do |t|
    t.boolean  "status",      default: false
    t.boolean  "paid",        default: false
    t.float    "charge",      default: 0.0
    t.integer  "user_id"
    t.string   "add_on"
    t.date     "active_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "attachments", force: true do |t|
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "basic_tasks", force: true do |t|
    t.boolean  "all_day",        default: true
    t.date     "start_at_date"
    t.date     "end_at_date"
    t.time     "start_at_time"
    t.time     "end_at_time"
    t.string   "title"
    t.string   "description"
    t.string   "repeat"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_completed",   default: false
    t.date     "completed_date"
    t.integer  "complete_by"
    t.string   "assigned_to"
    t.integer  "property_id"
    t.string   "event_type"
  end

  create_table "beta", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "feedback"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calls", force: true do |t|
    t.string   "call_sid"
    t.integer  "ivr_id"
    t.string   "caller"
    t.string   "caller_city"
    t.string   "caller_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caller_number"
  end

  create_table "chamicals", force: true do |t|
    t.integer  "property_id"
    t.integer  "work_order_id"
    t.integer  "applicator_id"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "mixture_short_name"
    t.string   "chemicals"
    t.string   "targeted_pest"
    t.string   "total_applied"
    t.string   "total_area_of_application"
    t.string   "application_rate"
    t.string   "wind_direction"
    t.string   "wind_velocity"
    t.string   "temperature"
    t.text     "apparatus_info"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "charges", force: true do |t|
    t.string   "name"
    t.string   "card_number"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.integer  "cvc"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip_code"
    t.string   "transaction_id"
    t.string   "email"
    t.float    "amount"
    t.boolean  "paid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addon_amount",   default: 0
    t.string   "addons_id"
    t.date     "active_date"
    t.string   "customer_id"
    t.string   "account_status"
  end

  create_table "chat_messages", force: true do |t|
    t.text     "body"
    t.integer  "chat_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chat_messages", ["chat_id"], name: "index_chat_messages_on_chat_id", using: :btree
  add_index "chat_messages", ["user_id"], name: "index_chat_messages_on_user_id", using: :btree

  create_table "chats", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chats", ["recipient_id"], name: "index_chats_on_recipient_id", using: :btree
  add_index "chats", ["sender_id"], name: "index_chats_on_sender_id", using: :btree

  create_table "chemical_items", force: true do |t|
    t.boolean  "liquid_chlorine_select",    default: true
    t.string   "liquid_chlorine_gal"
    t.boolean  "di_chlor_select"
    t.string   "di_chlor_ib"
    t.boolean  "tri_chlor_select"
    t.string   "tri_chlor_ib"
    t.boolean  "muriatic_acid_select"
    t.string   "muriatic_acid_gal"
    t.boolean  "dry_muriatic_acid_select"
    t.string   "dry_muriatic_acid_lb"
    t.boolean  "bromine_tans_select"
    t.string   "bromine_tans"
    t.boolean  "soda_ash_select"
    t.string   "soda_ash_lb"
    t.boolean  "sodium_bicarbonate_select", default: true
    t.string   "sodium_bicarbonate_lb"
    t.boolean  "salt_bags_select"
    t.string   "salt_bags"
    t.boolean  "water_clarifier_select",    default: true
    t.string   "water_clarifier_oz"
    t.boolean  "algacide_oz_select"
    t.string   "algacide_oz"
    t.boolean  "phosphate_remover_select",  default: true
    t.string   "phosphate_remover"
    t.integer  "property_id"
    t.string   "date"
    t.string   "source"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chemical_treatment_mixtures", force: true do |t|
    t.string   "name"
    t.string   "targeted_pest"
    t.text     "chemicals"
    t.string   "concentration"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chemical_treatment_setting_id"
  end

  create_table "chemical_treatment_settings", force: true do |t|
    t.string   "company_license_no"
    t.text     "users_attributes"
    t.text     "chemicals"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "classifieds", force: true do |t|
    t.string   "privacy"
    t.string   "contact_phone"
    t.string   "contact_text"
    t.string   "phone_number"
    t.string   "contact_name"
    t.string   "posting_title"
    t.string   "specific_location"
    t.string   "postal_code"
    t.text     "posting_body"
    t.boolean  "show_on_map"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.boolean  "contact_ok"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "license"
    t.string   "license_info"
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "initial"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company_name"
    t.boolean  "primary_company"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.string   "phone_initial"
    t.integer  "phone_number",            limit: 8
    t.string   "email_initial"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "client_tag"
    t.text     "custom_field"
    t.string   "mobile_number"
    t.string   "personal_email"
    t.string   "preference_notification"
    t.boolean  "demo_entry",                        default: true
  end

  create_table "communications", force: true do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.date     "sent_date"
    t.string   "to"
    t.string   "cc"
    t.string   "subject"
    t.text     "message"
    t.string   "status"
    t.string   "type"
    t.string   "send_copy"
    t.time     "sent_time"
    t.date     "opened_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "company_name"
    t.string   "company_phone"
    t.string   "company_email"
    t.string   "company_website"
    t.text     "company_address"
    t.boolean  "company_logo_show"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_logo_file_name"
    t.string   "company_logo_content_type"
    t.integer  "company_logo_file_size"
    t.datetime "company_logo_updated_at"
    t.string   "start_week_on"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
  end

  create_table "coupon_stripes", force: true do |t|
    t.string   "coupon_id"
    t.string   "coupon_release"
    t.string   "percent_off"
    t.string   "currency"
    t.string   "duration"
    t.integer  "times_redeemed"
    t.boolean  "coupon_valid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_categories", force: true do |t|
    t.string   "category"
    t.string   "user_id"
    t.string   "category_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_defaults", force: true do |t|
    t.text     "invoice_default"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "remainder",       default: false
    t.integer  "days"
    t.text     "template"
  end

  create_table "custom_expenses", force: true do |t|
    t.float    "mileage"
    t.float    "km"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_unit"
  end

  create_table "custom_fields", force: true do |t|
    t.string   "applies_to"
    t.string   "name"
    t.string   "value_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "digits", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "file_type"
  end

  create_table "email_notifications", force: true do |t|
    t.string   "from"
    t.string   "to"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_read",            default: false
    t.string   "email_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "bcc"
    t.string   "cc"
    t.string   "subject"
  end

  create_table "email_scrapers", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "profession"
    t.string   "city"
    t.string   "state"
    t.text     "address"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "domain"
    t.boolean  "mail_sent"
    t.boolean  "seo_marketing"
  end

  create_table "emails", force: true do |t|
    t.string   "email_initial"
    t.string   "email"
    t.integer  "client_id"
    t.string   "primary_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "user_id"
    t.boolean  "all_day",     default: false
    t.integer  "property_id"
    t.string   "event_type"
  end

  create_table "expenses", force: true do |t|
    t.date     "clean_date"
    t.string   "name"
    t.text     "note"
    t.float    "cost"
    t.integer  "reimbursable_to_id"
    t.integer  "job_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "pending_payment",    default: false
    t.string   "exp_category"
    t.float    "miles"
    t.string   "unit"
    t.string   "exp_reimbursable"
    t.string   "exp_billable"
    t.string   "expense_type"
    t.string   "expense_image"
  end

  create_table "feedbacks", force: true do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.boolean  "like"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "scheduling"
    t.boolean  "submenu"
    t.boolean  "api"
    t.boolean  "analytics"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
  end

  create_table "fuels", force: true do |t|
    t.integer  "vehicle_id"
    t.string   "date"
    t.string   "odometer"
    t.boolean  "mark_as_void"
    t.float    "price"
    t.string   "fuel_type"
    t.string   "vandor_name"
    t.string   "reference"
    t.boolean  "mark_as_expense"
    t.boolean  "partial_fuel_up"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "general_infos", force: true do |t|
    t.integer  "default_tax"
    t.string   "tax_reg_type"
    t.string   "tax_reg_number"
    t.string   "country"
    t.string   "language"
    t.string   "work_start_day"
    t.string   "work_end_day"
    t.string   "week_day"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "company_phone"
    t.string   "service_number"
    t.string   "area_code"
    t.string   "zipcode"
    t.string   "service_tax"
    t.string   "currency"
  end

  create_table "invoice_works", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "quantity"
    t.string   "unit_cost"
    t.string   "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invoice_id"
  end

  create_table "invoices", force: true do |t|
    t.string   "payment"
    t.text     "subject"
    t.date     "issued_date"
    t.float    "tax"
    t.float    "discount_amount"
    t.string   "discount_type"
    t.float    "deposite_amount"
    t.date     "entry_date"
    t.string   "payment_method_type"
    t.string   "payment_method"
    t.text     "additional_note"
    t.text     "client_message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.date     "due_date"
    t.integer  "user_id"
    t.string   "jobs_id"
    t.boolean  "mark_sent",           default: false
    t.boolean  "invoice_paid",        default: false
    t.boolean  "invoice_bad_debt",    default: false
    t.boolean  "past_due",            default: false
    t.text     "custom_field"
    t.boolean  "is_mailed",           default: false
    t.integer  "invoice_order",       default: 0
    t.integer  "quote_id"
    t.boolean  "demo_entry",          default: true
    t.boolean  "status",              default: false
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "product_model_number"
    t.string   "vendor_part_number"
    t.string   "vendor_name"
    t.integer  "quantity"
    t.float    "unit_value"
    t.float    "value"
    t.string   "vendor_url"
    t.string   "category"
    t.string   "location"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.string   "l_name"
    t.string   "l_description"
    t.string   "l_product_model"
    t.string   "l_vendor_part"
    t.string   "l_vendor_name"
    t.string   "l_quantity"
    t.string   "l_unit"
    t.string   "l_value"
    t.string   "l_vendor_url"
    t.string   "l_category"
    t.string   "l_location"
    t.string   "l_image"
    t.text     "custom_field"
  end

  create_table "ivrs", force: true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.boolean  "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_sub_menu"
    t.boolean  "free"
    t.string   "application_id"
    t.string   "user_email"
    t.boolean  "is_template"
    t.string   "template_code"
    t.string   "region",         default: "USA"
    t.string   "uuid"
    t.string   "state"
    t.integer  "call_balance"
    t.string   "account_sid",    default: "ACc9f80c975d0574058948613554ca5adf"
    t.string   "auth_token",     default: "4dc2192cd7088ed3728b9899ff3b15bf"
    t.integer  "number_id"
  end

  create_table "job_works", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "quantity"
    t.integer  "unit_cost"
    t.integer  "total"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: true do |t|
    t.text     "description"
    t.boolean  "scheduled"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "visits"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "crew"
    t.string   "invoicing"
    t.string   "invoice_period"
    t.date     "first_invoice_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_id"
    t.string   "job_type"
    t.integer  "number_of_invoice"
    t.string   "invoice_type"
    t.integer  "user_id"
    t.string   "job_status"
    t.string   "job_required"
    t.boolean  "job_complete",      default: false
    t.date     "complete_on"
    t.integer  "quote_id"
    t.text     "custom_field"
    t.integer  "job_order",         default: 0
    t.boolean  "demo_entry",        default: true
    t.boolean  "status",            default: false
  end

  create_table "key_actions", force: true do |t|
    t.integer  "key_id"
    t.integer  "action_type_id"
    t.integer  "sequence"
    t.text     "say"
    t.string   "play"
    t.string   "dial"
    t.text     "record"
    t.string   "gather"
    t.text     "sms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "key_descriptions", force: true do |t|
    t.integer  "key_number"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keys", force: true do |t|
    t.integer  "ivr_id"
    t.string   "digit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "action_type_id"
    t.integer  "display_order"
  end

  create_table "lead_templates", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pool_activity_type"
  end

  create_table "mailboxer_conversation_opt_outs", force: true do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "mb_opt_outs_on_conversations_id", using: :btree

  create_table "mailboxer_conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree

  create_table "mailboxer_receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree

  create_table "market_sources", force: true do |t|
    t.string   "source_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", force: true do |t|
    t.integer  "key_action_id"
    t.integer  "sub_menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.text     "note"
    t.integer  "quote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
    t.integer  "invoice_id"
    t.integer  "client_id"
    t.integer  "property_id"
  end

  create_table "notifications", force: true do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.string   "notification_day"
    t.time     "notification_time"
    t.string   "team_mobile_number"
    t.string   "team_notification_by"
    t.string   "team_notification_preference"
    t.string   "client_mobile_number"
    t.string   "client_notification_by"
    t.string   "client_notification_preference"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "team_email"
    t.text     "team_sms"
    t.text     "client_email"
    t.text     "client_sms"
  end

  create_table "numbers", force: true do |t|
    t.string   "account_sid"
    t.string   "auth_token"
    t.string   "phone_number"
    t.string   "phone_sid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "voice"
    t.string   "sms"
    t.integer  "ivr_id"
  end

  create_table "parts", force: true do |t|
    t.string   "item_code"
    t.text     "description"
    t.float    "sales_price"
    t.string   "sales_code"
    t.float    "purchase_price"
    t.string   "purchase_code"
    t.float    "profit"
    t.string   "margin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "l_item"
    t.string   "l_description"
    t.string   "l_p_price"
    t.string   "l_p_code"
    t.string   "l_s_price"
    t.string   "l_s_code"
    t.string   "l_profit"
    t.string   "l_margin"
    t.text     "custom_field"
  end

  create_table "payment_invoices", force: true do |t|
    t.float    "pay_amount"
    t.date     "entry_date"
    t.string   "pay_method"
    t.string   "cheque_number"
    t.string   "transaction_number"
    t.string   "confirmation_number"
    t.text     "additional_note"
    t.integer  "user_id"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "transaction_type"
    t.integer  "client_id"
  end

  create_table "payment_terminals", force: true do |t|
    t.integer  "client_id"
    t.float    "amount"
    t.text     "description"
    t.string   "payment_type"
    t.string   "name"
    t.string   "email"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.string   "name_on_card"
    t.string   "card_number"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.integer  "cvc"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_id"
  end

  create_table "pdf_settings", force: true do |t|
    t.boolean  "show_company_name_on_pdfs",          default: true
    t.boolean  "pdf_shows_phone",                    default: true
    t.boolean  "pdf_shows_email",                    default: true
    t.boolean  "pdf_shows_website",                  default: true
    t.boolean  "pdf_shows_client_phone",             default: true
    t.boolean  "invoice_show_line_item_qty",         default: true
    t.boolean  "invoice_show_line_item_unit_costs",  default: true
    t.boolean  "invoice_show_line_item_total_costs", default: true
    t.boolean  "pdf_return_stub",                    default: true
    t.boolean  "invoice_show_late_stamp",            default: true
    t.boolean  "invoice_show_account_balance",       default: true
    t.text     "invoice_contract"
    t.boolean  "change_quote_to_estimate",           default: true
    t.boolean  "quote_show_line_item_qty",           default: true
    t.boolean  "quote_show_line_item_unit_costs",    default: true
    t.boolean  "quote_show_line_item_total_costs",   default: true
    t.boolean  "quote_show_totals",                  default: true
    t.boolean  "quote_client_signature",             default: true
    t.text     "quote_contract"
    t.boolean  "require_work_order_signature",       default: true
    t.text     "work_order_contract"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "permissions", force: true do |t|
    t.string   "permission_tasks"
    t.boolean  "permission_show_pricing",      default: false
    t.string   "permission_client_properties"
    t.string   "permission_quotes"
    t.string   "permission_invoices"
    t.string   "permission_jobs"
    t.string   "permission_note_attachment"
    t.boolean  "permission_reports",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_member_id"
    t.string   "to_dos"
    t.string   "company_admin"
    t.integer  "user_id"
  end

  create_table "phone_numbers", force: true do |t|
    t.string   "phone_number"
    t.string   "pin"
    t.boolean  "verified"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", force: true do |t|
    t.string   "phone_initial"
    t.string   "phone_number"
    t.string   "primary_phone"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pool_data", force: true do |t|
    t.string   "pool_type"
    t.string   "pool_shape"
    t.string   "pool_size"
    t.string   "pool_gallonage"
    t.string   "equip_pump_brand"
    t.string   "equip_model"
    t.string   "equip_horsepower"
    t.string   "equip_service_factor"
    t.string   "equip_voltage"
    t.string   "filter_brand"
    t.string   "filter_model"
    t.string   "filter_type"
    t.string   "filter_cartridge"
    t.string   "filter_date_replaced"
    t.string   "filter_de"
    t.string   "heater_brand"
    t.string   "heater_model"
    t.string   "heater_size"
    t.string   "heater_type"
    t.string   "time_clock_brand"
    t.string   "time_clock_model"
    t.string   "time_clock_voltage"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_id"
    t.float    "depth"
    t.float    "depth2"
    t.float    "length"
    t.float    "width"
    t.float    "width2"
    t.float    "diameter"
  end

  create_table "pool_services", force: true do |t|
    t.string   "ph_low"
    t.string   "ph_high"
    t.boolean  "ph_select"
    t.string   "ch_low"
    t.string   "ch_high"
    t.boolean  "ch_select"
    t.string   "combined_ch_low"
    t.string   "combined_ch_high"
    t.boolean  "combined_select"
    t.string   "alkalinity_low"
    t.string   "alkalinity_high"
    t.boolean  "alkalinity_select"
    t.string   "calcium_hardness_low"
    t.string   "calcium_hardness_high"
    t.boolean  "calcium_select"
    t.string   "stabilizer_low"
    t.string   "stabilizer_high"
    t.boolean  "stabilizer_select"
    t.string   "salt_low"
    t.string   "salt_high"
    t.boolean  "salt_select"
    t.string   "dissolved_soild_low"
    t.string   "dissolved_soild_high"
    t.boolean  "dissolved_select"
    t.string   "saturation_index_low"
    t.string   "saturation_index_high"
    t.boolean  "saturation_select"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pool_tests", force: true do |t|
    t.string   "chlorine"
    t.string   "ph_value"
    t.string   "salt_level"
    t.string   "total_alkalinity"
    t.string   "calcium_hardness"
    t.string   "source"
    t.string   "date"
    t.integer  "property_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pools", force: true do |t|
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "postcards", force: true do |t|
    t.string   "from_name"
    t.string   "from_street"
    t.string   "from_city"
    t.string   "from_state"
    t.string   "from_zipcde"
    t.string   "from_country"
    t.string   "to_name"
    t.string   "to_street"
    t.string   "to_city"
    t.string   "to_state"
    t.string   "to_zipcode"
    t.string   "to_country"
    t.text     "message"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "post_card_id"
  end

  create_table "properties", force: true do |t|
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.integer  "user_id"
    t.text     "custom_field"
    t.boolean  "add_route",       default: false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "demo_entry",      default: true
    t.string   "pool_name"
    t.string   "pool_activity"
    t.string   "pool_type"
    t.string   "pool_volume"
    t.string   "pool_volume2"
    t.string   "pool_gate_code"
    t.integer  "pool_lifeguards"
    t.text     "pool_notes"
    t.string   "market_source"
    t.integer  "server_plan_id"
    t.string   "estimate_map"
    t.boolean  "lead",            default: false
    t.text     "pool_tag"
    t.string   "pool_source"
    t.string   "converted_date"
    t.string   "pool_subject"
    t.text     "pool_comment"
    t.string   "source"
  end

  create_table "property_calls", force: true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "user_id"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quote_works", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "quantity"
    t.string   "unit_cost"
    t.string   "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quote_id"
  end

  create_table "quotes", force: true do |t|
    t.float    "tax"
    t.float    "discount"
    t.string   "discount_type"
    t.float    "require_deposit"
    t.string   "require_deposit_type"
    t.text     "client_message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_id"
    t.integer  "raty_score"
    t.integer  "user_id"
    t.boolean  "archive",              default: false
    t.boolean  "sent",                 default: false
    t.text     "custom_field"
    t.boolean  "is_mailed",            default: false
    t.integer  "quote_order",          default: 0
    t.boolean  "demo_entry",           default: true
  end

  create_table "repeats", force: true do |t|
    t.string   "frequency"
    t.integer  "daily_interval"
    t.integer  "weekly_interval"
    t.string   "day_holder"
    t.integer  "monthly_interval"
    t.string   "monthly_rule_type"
    t.string   "calender_day"
    t.string   "calander_week"
    t.integer  "yearly_interval"
    t.string   "invoicing"
    t.string   "visits"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reservations", force: true do |t|
    t.integer  "user_id"
    t.integer  "ivr_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_items", force: true do |t|
    t.boolean  "filter_cleaned"
    t.boolean  "netted_surface_debris"
    t.boolean  "brushed_walls_steps"
    t.boolean  "cleaned_skimmer_baskets"
    t.boolean  "cleaned_pump_basket"
    t.boolean  "vacuumed_pool"
    t.boolean  "checked_water_level"
    t.boolean  "inspected_pump"
    t.text     "notes_to_customer"
    t.integer  "user_id"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "service_plan_labels", force: true do |t|
    t.string   "filter_cleaned"
    t.string   "backwash"
    t.string   "brushed_walls_steps"
    t.string   "skimming_surface"
    t.string   "waterline_tiles_cleaned"
    t.string   "cleaned_skimmer_baskets"
    t.string   "netted_surface_debris"
    t.string   "floor_vacuumed"
    t.string   "pump_strainer_baskets"
    t.string   "cleaned_pump_basket"
    t.string   "vacuumed_pool"
    t.string   "checked_water_level"
    t.string   "inspected_pump"
    t.string   "pool_sweep_cleaner"
    t.string   "net_surface_bottom"
    t.string   "inspect_pool_spa_eqip"
    t.string   "wipe_ladder_handrails"
    t.string   "add_water_needed"
    t.string   "filter_pressure_monitor"
    t.string   "adjust_timeclock"
    t.string   "notes_to_customer"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_plans", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.float    "unit_cost"
    t.integer  "property_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "filter_cleaned"
    t.boolean  "backwash"
    t.boolean  "brushed_walls_steps"
    t.boolean  "skimming_surface"
    t.boolean  "waterline_tiles_cleaned"
    t.boolean  "cleaned_skimmer_baskets"
    t.boolean  "netted_surface_debris"
    t.boolean  "floor_vacuumed"
    t.boolean  "pump_strainer_baskets"
    t.boolean  "cleaned_pump_basket"
    t.boolean  "vacuumed_pool"
    t.boolean  "checked_water_level"
    t.boolean  "inspected_pump"
    t.boolean  "pool_sweep_cleaner"
    t.boolean  "net_surface_bottom"
    t.boolean  "inspect_pool_spa_eqip"
    t.boolean  "wipe_ladder_handrails"
    t.boolean  "add_water_needed"
    t.boolean  "filter_pressure_monitor"
    t.boolean  "notes_to_customer"
    t.boolean  "adjust_timeclock"
    t.string   "status"
    t.text     "customer_note"
  end

  create_table "service_products", force: true do |t|
    t.string   "item_type"
    t.string   "name"
    t.text     "description"
    t.float    "unit_cost"
    t.boolean  "non_taxable", default: false
    t.integer  "user_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_reminders", force: true do |t|
    t.string   "vehicle_name"
    t.string   "service_task"
    t.string   "meter_interval"
    t.float    "time_interval"
    t.string   "time_duration"
    t.float    "meter_threshold"
    t.float    "time_threshold"
    t.string   "threshold_duration"
    t.boolean  "email_notification"
    t.string   "subscribed_user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "services", force: true do |t|
    t.string   "date"
    t.integer  "vehicle_id"
    t.string   "odometer"
    t.boolean  "mark_as_void"
    t.string   "services_completed"
    t.string   "vendor"
    t.string   "reference"
    t.text     "comment"
    t.float    "labor"
    t.float    "parts"
    t.float    "tax"
    t.float    "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "service_image_file_name"
    t.string   "service_image_content_type"
    t.integer  "service_image_file_size"
    t.datetime "service_image_updated_at"
  end

  create_table "sms_properties", force: true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "other_number"
    t.string   "body"
    t.integer  "property_id"
    t.integer  "user_id"
    t.string   "sms_twilio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spa_data", force: true do |t|
    t.string   "spa_type"
    t.string   "type_manufacturer"
    t.string   "type_model"
    t.string   "type_serial_number"
    t.string   "type_color"
    t.string   "type_voltage"
    t.string   "spa_shape"
    t.string   "spa_size"
    t.string   "spa_gallonage"
    t.string   "surface_material"
    t.string   "equip_pump_brand"
    t.string   "equip_model"
    t.string   "equip_horsepower"
    t.string   "equip_service_factor"
    t.string   "equip_voltage"
    t.string   "filter_brand"
    t.string   "filter_model"
    t.string   "filter_type"
    t.string   "cartridge_size"
    t.string   "cartridge_part"
    t.string   "cartridge_date"
    t.string   "filter_sand_model"
    t.string   "filter_sand_size"
    t.string   "filter_de"
    t.string   "heater_brand"
    t.string   "heater_model"
    t.string   "heater_type"
    t.string   "time_clock_brand"
    t.string   "time_clock_model"
    t.string   "time_clock_voltage"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "depth"
    t.float    "depth2"
    t.float    "length"
    t.float    "width"
    t.float    "width2"
    t.float    "diameter"
  end

  create_table "spa_services", force: true do |t|
    t.string   "ph_low"
    t.string   "ph_high"
    t.boolean  "ph_select"
    t.string   "ch_low"
    t.string   "ch_high"
    t.boolean  "ch_select"
    t.string   "combined_ch_low"
    t.string   "combined_ch_high"
    t.boolean  "combined_select"
    t.string   "alkalinity_low"
    t.string   "alkalinity_high"
    t.boolean  "alkalinity_select"
    t.string   "calcium_hardness_low"
    t.string   "calcium_hardness_high"
    t.boolean  "calcium_select"
    t.string   "stabilizer_low"
    t.string   "stabilizer_high"
    t.boolean  "stabilizer_select"
    t.string   "salt_low"
    t.string   "salt_high"
    t.boolean  "salt_select"
    t.string   "dissolved_soild_low"
    t.string   "dissolved_soild_high"
    t.boolean  "dissolved_select"
    t.string   "saturation_index_low"
    t.string   "saturation_index_high"
    t.boolean  "saturation_select"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supports", force: true do |t|
    t.string   "email"
    t.string   "title"
    t.text     "description"
    t.string   "phone_number"
    t.string   "about"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "team_members", force: true do |t|
    t.integer  "member_id"
    t.integer  "user_id"
    t.boolean  "active",             default: true
    t.boolean  "login_access",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "ssn_number"
    t.date     "start_date"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "custom_field"
    t.boolean  "is_admin",           default: false
    t.string   "mobile_number"
    t.string   "preference"
    t.string   "marker_color"
    t.string   "last_name"
  end

  create_table "timesheets", force: true do |t|
    t.integer  "user_id"
    t.date     "start_date"
    t.boolean  "auto_start_timer"
    t.integer  "job_id"
    t.string   "label"
    t.text     "note"
    t.time     "start_time"
    t.time     "end_time"
    t.time     "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "day"
    t.integer  "custom_category_id"
    t.boolean  "billable",           default: false
    t.boolean  "sync_type",          default: false
  end

  create_table "tracks", force: true do |t|
    t.string   "latitude"
    t.string   "longitude"
    t.integer  "user_id"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "call_id"
    t.string   "key_press"
    t.integer  "key_action_id"
    t.string   "recording"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twilio_location"
  end

  create_table "users", force: true do |t|
    t.string   "email",                     default: "",    null: false
    t.string   "encrypted_password",        default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name"
    t.string   "full_name"
    t.string   "phone_number"
    t.string   "username"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "ssn"
    t.datetime "start_date"
    t.string   "user_type"
    t.string   "company_logo_file_name"
    t.string   "company_logo_content_type"
    t.integer  "company_logo_file_size"
    t.datetime "company_logo_updated_at"
    t.string   "plan_type"
    t.boolean  "cancel_account",            default: false
    t.string   "qb_token"
    t.string   "qb_secret"
    t.string   "qb_realm_id"
    t.string   "referral_code"
    t.string   "mobile_number"
    t.string   "message_notify"
    t.text     "statement"
    t.string   "statement_order"
    t.boolean  "setup_complete",            default: false
    t.integer  "employee_id"
    t.boolean  "demo_active",               default: true
    t.string   "marker_color"
    t.string   "item_head"
    t.string   "part_head"
    t.boolean  "hr_document",               default: false
    t.boolean  "company_document",          default: false
    t.boolean  "contract_document",         default: false
    t.boolean  "verified",                  default: false
    t.string   "pin"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "vehicles", force: true do |t|
    t.string   "vehicle_name"
    t.string   "vin_no"
    t.string   "vehicle_type"
    t.string   "year"
    t.string   "make"
    t.string   "model"
    t.string   "trim"
    t.string   "license_plate"
    t.string   "registation"
    t.string   "status"
    t.string   "group"
    t.string   "driver"
    t.string   "ownership"
    t.string   "color"
    t.string   "body_type"
    t.string   "body_subtype"
    t.float    "msrp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "vehicle_image_file_name"
    t.string   "vehicle_image_content_type"
    t.integer  "vehicle_image_file_size"
    t.datetime "vehicle_image_updated_at"
  end

  create_table "vendor_settings", force: true do |t|
    t.string   "vendor_type"
    t.string   "vendor_miles"
    t.text     "preference_vendor"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "prefer_marker"
  end

  create_table "vendors", force: true do |t|
    t.string   "vendor_type"
    t.string   "name"
    t.string   "location_name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "fax"
    t.string   "source"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "visit_schedules", force: true do |t|
    t.string   "title"
    t.boolean  "any_time"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "team_reminder"
    t.text     "description"
    t.integer  "job_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "job_status"
    t.string   "job_required"
    t.boolean  "job_complete",  default: false
    t.date     "complete_on"
    t.string   "crew"
    t.string   "completed_by"
    t.string   "event_type"
  end

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", name: "mb_opt_outs_on_conversations_id", column: "conversation_id"

  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", name: "notifications_on_conversation_id", column: "conversation_id"

  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", name: "receipts_on_notification_id", column: "notification_id"

end
