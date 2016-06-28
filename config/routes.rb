Rails.application.routes.draw do

  
 # hhfhkdghkd
  resources :service_reminders

  resources :services

  resources :fuels

  resources :vehicles
  post 'pusher/auth'
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :invoices
  resources :supports
  resources :items do
    collection do
      get "inventory_head" 
      post "inventory_update"
    end
  end
  resources :parts
  namespace :api do
    namespace :v1 do
      post "/sign_in", :to => 'sessions#create'
      delete "/sign_out", :to => 'sessions#destroy'
      post "/sign_up", :to => 'registrations#create'
      post "/users/password", :to => 'passwords#create'
      get "/dashboards/username",:to =>'dashboards#username'
      get "/conversations/chat_user",:to =>'conversations#chat_user'
      post "/conversations/conversation_user",:to =>'conversations#conversation_user'
      post "/conversations/create",:to =>'conversations#create'
      get "/conversations/show_message",:to =>'conversations#show_message'
      get "/dashboards/weather",:to =>'dashboards#weather'
      get "/chemical_add",:to =>'chemicals#chemical_add'
      post "/chemical_used",:to =>'chemicals#chemical_used'
      get "/chemical_display",:to=>"chemicals#chemical_display"
      post "/chemical_test" , :to=>"chemicals#chemical_test"
      get "/view_chemical_result" , :to=>"chemicals#view_chemical_result"
      get "/chemical_test_range", :to=>"chemicals#chemical_test_range"
      get "/service_item", :to=>"chemicals#service_item"
      post "/service_item_create" ,:to=>"chemicals#service_item_create"
      get "/service_item_display", :to=>"chemicals#service_item_display"

      post "/charge_create",:to=>"charges#charge_create"
      post "/update_coordinates",:to=>"trackings#update_coordinates"
      get "/show_points",:to=>"trackings#show_points"
      get "/deactive_points",:to=>"trackings#deactive_points"
      resources :clients do
        member do
          get "client_property" 
          post "update_client"
        end
      end
      resources :jobs do
        collection do
          get "today_schedule"
          get 'signature_job'
        end
        member do
          get "job_invoice"
          post "update_job"
          post "close_job"
          post "job_payment"
          post "reopen_job"
        end
      end
      resources :properties do
        member do
          post "update_property"
        end
      end
      resources :items do
        member do
          post "update_item"
        end
      end
      resources :quotes do
        member do
          post "update_quote"
          get "find_quote"
          post "signature_quote"
          post "quotes_image"
          post "quote_image_save"
        end
      end
      resources :invoices do
        member do
        post "update_invoice" 
        end
      end
      resources :basic_tasks do 
        collection do
          get "today_task"
        end
        member do
          post "update_task"
        end

      end

      resources :timesheets do
        member do
        post "update_timesheet" 
        end
      end

      resources :home do
        collection do
          get "weather"
        end
      end

      resources :expenses do 
        member do   
         post "update_expense"  
        end
      end
    end
  end


  resources :numbers do
    collection do
      post :update_ivr_number
      post :search
    end
  end
  resources :key_actions

  resources :keys

  resources :ivrs do

    collection do
      post 'create_beta'
      post 'add_sub_menu'
      post 'create_feedback'
      post 'check_email'
      post 'key_description'
    end
    member do
      get 'twiml/repeat_menu(/:sub_menu_id)', :to => "ivrs#twiml_repeat_menu" , :as => :twiml_repeat
      get 'twiml(/:sub_menu_id)' , :to => "ivrs#twiml" , :as => :twiml
      #post 'twiml_for_client'
      get 'handle_recording'
      get 'calls'
      get 'release'
      get 'templates'
      get 'apply_template'
      post 'sms_callback'
      get 'analytics'
      post 'filters'
    end
  end

  get "action_types" => 'action_types#index'

  resources :conversations, only: [:index, :show, :new, :create] do
    member do
      post :reply
      post :trash
      post :untrash

    end
    collection do
      get :notify
      get :update_notify
      get :display_notify
    end

  end
  resources :classifieds do
    member do
      get :media
      patch :media_save
      post :media_save
    end 
  end

  resources :subscriptions do 
    collection do
      get :plan
      post :change_plan
      post :downgrade_plan
    end
  end
  resources :maps do
    collection do
      get :zoom
      get :optimize 
      get :assigned_team
      get :change_assign
      post :reassign
      get :map_show
      post :property_estimate
      get :lead
      get :add_marker
      post :display_address
      get :create_lead
      post :add_lead
    end
  end 
  resources :quotes
  resources :notifications 

  resources :events do
    collection do
      get :to_dos
      post :move
      post "visit_complete_event/:visit_id" => "events#visit_complete_event", as: "visit_complete_event" 
      get "visit_view_detail_event/:visit_id" => "events#visit_view_detail_event", as: "visit_view_detail_event"
      get "edit_visit_event/:visit_id" => "events#edit_visit_event", as: "edit_visit_event"
      post "update_visit_event/:visit_id" =>  "events#update_visit_event", as: "update_visit_event"
      get "destroy_visit_event/:job_id/:visit_id" =>  "events#destroy_visit_event", as: "destroy_visit_event"
      get 'new_job_event' => 'events#new_job_event', as: 'new_job_event'
      post 'search_job_client' => 'events#search_job_client', as: 'search_job_client'
    end
    get :view_detail
  end

  resources :basic_tasks do
    collection do
      get :to_dos 
      post :move
    end
    post :complete_basic_task
    get :view_detail
  end

  resources :jobs do 
    collection do 
      get "recurring_job"
    end
  end
  resources :properties do
    member do
      get :manually_geocode
      post "update_property"
    end
    collection do
      post :location_update
      post :property_service_plan
      post :pool_update_active
      get :convert_client
      post :converted
      # get :view_lead
      get :lead_message
      post :lead_message_pdf
      post :property_tag
      post :tag_delete
      post :templates_display
      get :email_message
      post :message_email_sent
      get :lead_mailer
    end
  end

  resources :spa_pooles do 
    collection do
      get :property_pool_data
      post :pool_data_create
      post :pool_data_update
      get :pool_data_edit
      get :spa_data
      post :spa_data_create
      get :spa_data_edit
      post :spa_data_update
      post :calculate_gallonage
      post :calculate_spa_volume
      post :pool_shape_change
      post :spa_shape_change
    end
  end

  #Dashboard new 7 april  
  get "/dashboard" =>"dashboards#dashboard"
  get "/get_summary_data" =>"dashboards#get_summary_data"
  get "/get_quick_links"  =>"dashboards#get_quick_links"
  get "/weather_data"  =>"dashboards#weather_data"

  resources :clients do
    collection do
      get :demo_deactive 
      get :new_client
    end
    member do
      post :payment
    end
  end

  resources :documents do
    collection do
      get :document_box
      get :document_setting
      post :document_check
    end
    member do
      get :download
      get :delete_account # admin delete its account
    end
  end

  resources :intuits do
    collection do
      get :authenticate
      get :oauth_callback
      get :closed_qb_account
    end
  end

  resources :email_notifications do
    collection do
      get 'reply_message' 
      post 'message_create' 
      get 'thanks_message'
      post 'email_read'
      get 'chat_popup'
    end
  end

  #Active addons route
  resources :timesheets do 
    collection do
      get 'prev_day'
      get 'next_day'
      get 'category_new'
      get 'payroll'
      get 'prev_payroll'
      get 'next_payroll'
      post 'category_update'
    end
    member do
      get 'category_edit'
      get 'category_delete'
    end
  end
  resources :expenses do
    collection do
      get 'mile_category' , :as => "expenses/mileage"
      post 'create_mileage'
      post 'category_create'
      post 'category_update'
    end
    member do
      get 'category_edit'
      get 'category_delete'
    end

  end
  resources :pool_services do 
    collection do 
      get "pool_service"
      get "spa_service"
      post "service_create"
      get "chemical_items"
      post "chemical_items_create" 
      get "pool_chemical_test"
      post "check_pool_test"
      get "chemical_used"
      post "chemical_used_create"
      get "service_items"
      post "service_items_create"
      get "market_source"
      post "source_create"
      post "source_update"
      get "service_plan"
      post "service_plan_create"
      post "service_plan_update"
      get :service_plan_label
      post :update_plan_label
    end
    member do
      get "source_edit"
      get "source_delete"
      get "service_plan_edit"
      get "service_plan_delete"
    end
  end
  resources :chamicals
  resources :postcards, only: [:index, :create] 
  #devise
  devise_for :users, :controllers => {:sessions=>"sessions",:confirmations=>"confirmations",:registrations => "registrations",:passwords=>"passwords",:omniauth_callbacks => "omniauth_callbacks"}
  
# COMMUNICATIONS PROPERTY VIEW START

  post '/twilio_call' =>"communications#twilio_call"
  post '/twilio_connect' =>"communications#twilio_connect"
  post '/property_note' =>"communications#property_note"
  post '/property_email' =>"communications#property_email"
  post '/property_sms'   =>"communications#property_sms"
  get '/more_activity'   =>"communications#more_activity"
  get '/edit_note_activity' =>"communications#edit_note_activity"
  post '/update_note_activty' =>"communications#update_note_activty"
  get '/filter_activity' =>"communications#filter_activity"
  post '/call_activity' =>"communications#call_activity"

  get "/communication_header" =>"communications#communication_header"
# COMMUNICATIONS PROPERTY VIEW END

# VENDORS VIEW START

  resources :vendors do 
    collection do
      post :import_vendor
      get :vendor_setting
      get :import_file
      post :vendor_customize
      post :search_vendors
      get :preference_vendors
      get :add_preference
    end
  end


#Chat routes Start
  resources :chats do
    resources :chat_messages
  end
#Chat routes END

# VENDORS VIEW END
  get '/backup' => "back_ups#back_check" ,:as=>"backup"
  get '/manage_data' => "back_ups#manage_data" ,:as=>"manage_data"
  get '/csv_generate' => "back_ups#csv_generate" ,:as=>"csv_generate"
  post '/csv_import' => "back_ups#csv_import" ,:as=>"csv_import"
  get '/csv_upload' => "back_ups#csv_upload" ,:as=>"csv_upload"
  get '/download_template' => "back_ups#download_template" ,:as=>"download_template"

  get '/leads' => "leads#view_lead"
  get '/import_lead' => "leads#import_lead"
  post '/import_file' => "leads#import_file"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  post 'quotes/new'
  post 'jobs/new'
  post 'properties/new'
  post 'invoices/new'
  # You can have the root of your site routed with "root"
  root 'home#index'
  post 'clients/create'
  post '/call' => "home#call"
  post '/connect' => "home#connect"
  post '/sms_notification_time' =>"home#sms_notification_time"
 
  get 'phone_numbers/check_validate' => "phone_numbers#check_validate"
  get '/resend_code' =>"phone_numbers#resend_code"
  resources :phone_numbers, only: [:create]
  post 'phone_numbers/verify' => "phone_numbers#verify"
  post '/basic_task_complete' => "properties#basic_task_complete" ,:as=>"basic_task_complete"
  post '/search_client_property' => "properties#search_client_property" ,:as=>"search_client_property"
  get '/property_basic_task' => "properties#property_basic_task" ,:as=>"property_basic_task"
  get '/property_event' => "properties#property_event" ,:as=>"property_event"
  post '/property_task_create' => "properties#property_task_create" 
  patch '/property_task_create' => "properties#property_task_create" 
 
  post '/property_event_create' => "properties#property_event_create"
  patch '/property_event_create' => "properties#property_event_create"
  post '/show_event_task' => "properties#show_event_task" ,:as=>"show_event_task"
  get '/edit_event_task' => "properties#edit_event_task" ,:as=>"edit_event_task"
  get '/delete_event_task' => "properties#delete_event_task" ,:as=>"delete_event_task"
 
  
  post '/search_invoice_client' => "clients#search_invoice_client" ,:as=>"search_invoice_client"
  post '/search_job_client' => "clients#search_job_client" ,:as=>"search_job_client"
  post '/tag_delete' => "clients#tag_delete" ,:as=>"tag_delete"
  post '/search_tag' => "clients#search_tag" ,:as=>"search_tag"
  post '/client_search' => "clients#client_search" ,:as=>"client_search"
  post '/client_tag' => "clients#client_tag" ,:as=>"client_tag"
  post '/client_search_key' => "clients#client_search_key" ,:as=>"client_search_key"
  post '/client_image_upload' => "clients#client_image_upload" ,:as=>"client_image_upload"
  get '/csv_export' => "clients#csv_export",:as=>"csv_export"
  get '/vfc_export' => "clients#vfc_export",:as=>"vfc_export"
  get '/note_destroy' => "clients#note_destroy" ,:as=>"note_destroy"
  get '/attachment_destroy' => "clients#attachment_destroy" ,:as=>"attachment_destroy"
  get '/edit_note' => "clients#edit_note" ,:as=>"edit_note"
  post '/update_note' => "clients#update_note" ,:as=>"update_note"
  get '/delete_client' => "clients#delete_client" ,:as=>"delete_client"
  post '/import_client' => "clients#import_client" ,:as=>"import_client"
  get '/select'  => "clients#select" ,:as=>"select"

  post '/get_end_date' => "jobs#get_end_date" ,:as=>"get_end_date"
  post '/job_sort' => "jobs#job_sort" ,:as=>"job_sort"
  get '/notice_mail/:id' => "jobs#notice_mail" ,:as=>"notice_mail"
  post '/job_type_sort' => "jobs#job_type_sort" ,:as=>"job_type_sort"
  get '/select_property' => "jobs#select_property" ,:as=>"select_property"
  get '/work' => "jobs#work" ,:as=>"work"
  post '/job_search' => "jobs#job_search" ,:as=>"job_search"
  post '/job_image_upload' => "jobs#job_image_upload" ,:as=>"job_image_upload"
  post '/search_coming_job' => "jobs#search_coming_job" ,:as=>"search_coming_job"
  post '/status_edit_job/:job_id' => "jobs#status_edit_job" ,:as=>"status_edit_job"
  get '/required_edit_job' => "jobs#required_edit_job" ,:as=>"required_edit_job"
  get '/job_pdf' => "jobs#job_pdf" ,:as=>"job_pdf"
  post '/job_work' => "jobs#job_work" ,:as=>"job_work"
  post '/attach_client_sign' => "jobs#attach_client_sign",:as=>"attach_client_sign"
  get '/genrate_job_invoice' => "jobs#genrate_job_invoice" ,:as=>"genrate_job_invoice"
  post '/job_completed' => "jobs#job_completed",:as=>"job_completed"
  post '/job_visit_plan' => "jobs#job_visit_plan",:as=>"job_visit_plan"
  post '/job_work_destroy/:job_work_id' => 'jobs#job_work_destroy', as: "job_work_destroy"
  post 'job_form_change' => 'jobs#job_form_change', as: 'job_form_change'
  get 'job_assigned_visit/:visit_id' => 'jobs#job_assigned_visit', as: 'job_assigned_visit'
  get 'edit_visit_plan/:visit_id' => 'jobs#edit_visit_plan', as: 'edit_visit_plan'
  post 'update_visit_plan' => 'jobs#update_visit_plan', as: 'update_visit_plan'
  get 'destroy_visit_plan/:job_id/:visit_id' => 'jobs#destroy_visit_plan', as: 'destroy_visit_plan'

  post '/quote_client_sign' => "quotes#quote_client_sign",:as=>"quote_client_sign"
  post '/quote_image_upload' => "quotes#quote_image_upload" ,:as=>"quote_image_upload"
  get '/property_select' => "quotes#property_select" ,:as=>"property_select"
  get '/add_work_quote' => "quotes#add_work_quote" ,:as=>"add_work_quote"
  post '/search_quote_client' => "quotes#search_quote_client" ,:as=>"search_quote_client"
  post '/quote_sort' => "quotes#quote_sort" ,:as=>"quote_sort"
  post '/sort_by_time' => "quotes#sort_by_time" ,:as=>"sort_by_time"
  get '/quote_pdf' => "quotes#quote_pdf" ,:as=>"quote_pdf"
  get '/blank_quote'=>"quotes#blank_quote",:as=>"blank_quote"
  get '/client_select'=>"quotes#client_select",:as=>"client_select"
  get '/quote_sent'=>"quotes#quote_sent",:as=>"quote_sent"
  get '/quote_archive'=>"quotes#quote_archive",:as=>"quote_archive"
  post '/quote_sort_archive' => "quotes#quote_sort_archive" ,:as=>"quote_sort_archive"
  post '/item_service_description'=>"quotes#item_service_description"
   
  get '/invoice_payment_thanks'=>"invoices#invoice_payment_thanks",:as=>"invoice_payment_thanks" 
  post '/payment_done'=>"invoices#payment_done",:as=>"payment_done" 
  get '/invoice_payment_show/:id'=>"invoices#invoice_payment_show",:as=>"invoice_payment_show" 
  get '/payment_invoice'=>"invoices#payment_invoice",:as=>"payment_invoice"
  get '/mark_sent_invoice'=>"invoices#mark_sent_invoice",:as=>"mark_sent_invoice"
  post '/invoice_payment_create'=>"invoices#invoice_payment_create",:as=>"invoice_payment_create"
  get '/reopen_invoice'=>"invoices#reopen_invoice",:as=>"reopen_invoice"
  get '/bad_debt_invoice'=>"invoices#bad_debt_invoice",:as=>"bad_debt_invoice"
  post '/invoice_sort' => "invoices#invoice_sort" ,:as=>"invoice_sort"
  post '/invoice_image_upload' => "invoices#invoice_image_upload" ,:as=>"invoice_image_upload"
  post '/sort_invoice_time' => "invoices#sort_invoice_time" ,:as=>"sort_invoice_time"
  get '/invoice_pdf' => "invoices#invoice_pdf" ,:as=>"invoice_pdf"
  post '/invoice_client_sign' => "invoices#invoice_client_sign",:as=>"invoice_client_sign"
  post '/sort_invoice_outstanding' => "invoices#sort_invoice_outstanding" ,:as=>"sort_invoice_outstanding"

  get '/setup_complete'=>"home#setup_complete",:as=>"setup_complete"
  get '/company_edit'=>"home#company_edit",:as=>"company_edit"
  
  get '/cancel_account'=>"home#cancel_account",:as=>"cancel_account"
  get '/contact'=>"home#contact",:as=>"contact"
  get '/pricing'=>"home#pricing",:as=>"pricing"
  get '/blog'=>"home#blog",:as=>"blog"
  get '/about_us'=>"home#about_us",:as=>"about_us"
  get '/tour'=>"home#tour",:as=>"tour"
  get '/reports' => "home#reports" ,:as=>"reports"
  get '/reports/client_list' => "home#client_list" ,:as=>"client_list"

  #Recurring contracts routes 
  get '/reports/contracts' => "home#recurring_contracts" ,:as=>"reports/contracts"
  get  '/reports/contracts/:any' => 'home#recurring_contracts'
  post '/reports/recurring_contracts_summary' => "home#recurring_contracts_summary"
  get  '/add_new_custom_field'=>"home#add_new_custom_field"
  get '/custom_field_delete/:id'=>"home#custom_field_delete",as: "custom_field_delete"
  #One off jobs routes
  get '/reports/one_off_jobs' => "home#job_list" ,:as=>"reports/one_off_jobs"
  get  '/reports/one_off_jobs/:any' => 'home#job_list'
  post '/reports/jobs_report_summary' => "home#jobs_report_summary"

  # Product and services routes
  get '/reports/products_and_services' => "home#products_and_services" ,:as=>"reports/products_and_services"
  get  '/reports/products_and_services/:any' => 'home#products_and_services'
  post '/reports/products_and_services_summary' => "home#products_and_services_summary"

  #Quotes summary routes
  get '/reports/quotes' => "home#quote_list" ,:as=>"/reports/quotes"
  get  '/reports/quotes/:any' => 'home#quote_list'
  post '/reports/quotes_report_summary' => "home#quotes_report_summary"

  #Visits sumary routes
  get '/reports/visits' => "home#visits_list" ,:as=>"/reports/visits"
  get  '/reports/visits/:any' => 'home#visits_list'
  post '/reports/visits_report_summary' => "home#visits_report_summary"

  #Transaction list sumary routes
  get '/reports/transactions' => "home#transactions" ,:as=>"/reports/transactions"
  get  '/reports/transactions/:any' => 'home#transactions'
  post '/reports/transactions_report_summary' => "home#transactions_report_summary"

  #Invoice summary routes
  get '/reports/invoice/' => "home#invoice_list", :as=> '/reports/invoice'
  get '/reports/invoice/:any' => "home#invoice_list"
  post '/reports/get_summary_report' => "home#get_summary_report"

  #Client Balance Summary routes
  get '/reports/client_balance/' => "home#client_balance", :as=> '/reports/client_balance'
  get '/reports/client_balance/:any' => "home#client_balance"
  post '/reports/client_balance_summary' => "home#client_balance_summary"

  #Client Balance Summary routes
  get '/reports/aged_receivables/' => "home#aged_receivables", :as=> '/reports/aged_receivables'
  get '/reports/aged_receivables/:any' => "home#aged_receivables"
  #post '/reports/client_balance_summary' => "home#client_balance_summary"

  #project income routes under management
  get '/reports/projected_income/' => "home#projected_income", :as=> '/reports/projected_income'
  get '/reports/projected_income/:any' => "home#projected_income"
  post '/reports/projected_income' => "home#projected_income_summary"

  #get emails communication under managment
  get '/reports/email_communications' => 'home#email_communication', as: '/reports/email_communications'
  post '/reports/emails_communication_summary' => 'home#emails_communication_summary'
  get '/open_email/:id' => 'home#open_email', as: 'open_email'
  #expenses in report management
  get '/reports/expenses' => 'home#expenses'
  get '/reports/expenses/:any' => "home#expenses"
  post '/reports/expenses' => "home#expenses_report_summary"

  #master route under management tab
  get '/insert_at_route'=>"maps#insert_at_route"
  get '/remove_at_route'=>"maps#remove_at_route"
  get '/routes' => 'maps#routes', as: '/routes'
  post '/routes_optization_pdf' => 'maps#routes_optization_pdf'
  post '/route_pdf_email' => 'maps#route_pdf_email'
  get '/route_optimize' => "maps#route_optimize" ,:as=>"route_optimize"
  #quick book show response 
  get 'accounts/syncer/qb_show' => 'home#qb_show', as: '/accounts/syncer/qb_show'

  # intute blue-dot
  get '/path/to/blue-dot' => 'home#bluedot'

  #syncronize to quick book
  post 'sync_to_quick_book' => 'intuits#sync_to_quick_book' 
 
  get 'get_edit_job/:job_work_id/:index' => 'jobs#get_edit_job', :as=> '/get_edit_job'
  post 'job_work_update/:job_work_id' => 'jobs#job_work_update', :as=> '/job_work_update'
  # get '/dashboard' => "home#dashboard" ,:as=>"dashboard"
  get '/work_items' => "home#work_items" ,:as=>"work_items"
  post '/product_service' => "home#product_service" ,:as=>"product_service"
  post '/product_service_edit' => "home#product_service_edit" ,:as=>"product_service_edit"
  get '/users' => "home#users" ,:as=>"users"
  get '/home/users/new' => "home#user_new" ,:as=>"/home/users/new"
  post '/home_create_user' => "home#home_create_user" ,:as=>"home_create_user"
  get '/users/first_login' => "home#first_login" ,:as=>"/users/first_login"
  get '/home/users/:id/edit' => "home#member_edit" ,:as=>"member_edit" 
  post '/home/users/update/:id' => "home#member_update" ,:as=>"member_update"
  get '/home/users/:id/deactive' => "home#deactive" ,:as=>"deactive" 
  get '/home/users/:id/:any' => "home#deactive" 

  get '/route_planner' => "home#route_planner" ,:as=>"route_planner"
 
  get '/home/users/:id' => "home#user_show" ,:as=>"user_show"
  get 'home/users' => "home#user_delete" ,:as=>"user_delete"
  post 'home/update_service/:id' => "home#update_service" ,:as=>"update_service"
  get 'home/delete_service/:id' => "home#delete_service" ,:as=>"delete_service"
  get '/work_configuration/edit' =>"home#company_brand"
  post '/company_brand_create' =>"home#company_brand_create",:as=>"company_brand_create"
  get '/custom_fields'=>"home#custom_field"
  post '/custom_field_create'=>"home#custom_field_create"
  get '/custom_field_edit'=>"home#custom_field_edit"
  post '/custom_field_update'=>"home#custom_field_update"
  get '/accounts/edit'=>"home#general_account"
  patch '/accounts/general_account_update'=>"home#general_account_update"
  post '/accounts/general_account_update'=>"home#general_account_update"
 

  #show payment popup on dash board
  get 'client_payment/:client_id' => 'home#client_payment', as: 'client_payment'
  post 'payment' => 'home#payment', as: 'payment'
  post 'reports/payment_update/:id' => 'home#payment_update', as: 'payment_update'
  #invoice reminder on manegement
  get 'open_payment_dialog/:payment_id' => 'home#open_payment_dialog', as: 'open_payment_dialog'
  get 'open_invoice_dialog/:invoice_id' => 'home#open_invoice_dialog', as: 'open_invoice_dialog'
  #Dialog for job complete but not paid
  get 'open_job_dialog/:id' => 'home#open_job_dialog', as: 'open_job_dialog'
  #send-mail
  post '/mail/:id/mail_to_client' => 'work_configurations#mail_to_client', as: 'mail_to_client'
  get 'email_action' => 'quotes#email_action', as: 'email_action'
  get 'invoice_email_action' => 'invoices#invoice_email_action', as: 'invoice_email_action'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get '/charges'=>"charges#index"
  get '/payment_terminal' => "charges#payment_terminal"
  post '/payment_terminal_set' => "charges#payment_terminal_set"
  get '/charges/new'=>"charges#new"
  post '/charges/create'=>"charges#create"
  get '/charges/account/referrals'=>"charges#referral"
  post '/charges/account/referral_update'=>"charges#referral_update"
  post '/charges/coupan_create' =>"charges#coupan_create"
  get '/charges/:id/receipt_pdf' =>"charges#receipt_pdf" ,as: "charges_receipt_pdf"
  get '/charges/:id/view_receipt'=>"charges#view_receipt" ,as: "view_receipt_charge"
  #chemical treatment routes
  get '/chemical_treatment_setting'=>"chamicals#chemical_treatment_setting", as: '/chemical_treatment_setting'
  post '/create_setting'=>"chamicals#create_setting", as: '/create_setting'
  post '/search_client' => 'chamicals#search_client', as: '/search_client'
  get '/properties/select/:client_id' => 'chamicals#select_property_chemical', as: '/properties/select'

  get '/chemical_treatment_mixture'=>"chamicals#chemical_treatment_mixture", as: '/chemical_treatment_mixture'
  post '/create_mixture'=>"chamicals#create_mixture", as: '/create_mixture'
  get '/edit_chemical_treatment_mixture/:id/edit' => 'chamicals#edit_chemical_treatment_mixture', as: 'edit_chemical_treatment_mixture'
  post '/update_mixture/:id' => 'chamicals#update_mixture', as: 'update_mixture'
  #add on page
  get 'accounts/billing_info/addons' => 'charges#add_on', as: "add_on"
  post 'addon_active' => 'charges#addon_active', as: 'addon_active'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  get '/work_configuration/edit/quotes'=>"work_configurations#quote_work_configuration"
  patch '/work_configuration/edit/quotes'=>"work_configurations#quote_work_configuration"
  get '/work_configuration/edit/work_orders'=>"work_configurations#job_work_configuration"
  patch '/work_configuration/edit/work_orders'=>"work_configurations#job_work_configuration"
  get '/work_configuration/edit/invoices'=>"work_configurations#invoice_work_configuration"
  patch '/work_configuration/edit/statements'=>"work_configurations#statement_work_configuration"
  get '/work_configuration/edit/statements'=>"work_configurations#statement_work_configuration"
  get '/work_configuration/edit/email_options'=>"work_configurations#email_option_work_configuration"
  get '/work_configuration/edit/organizer'=>"work_configurations#organizer_work_configuration"
  post '/work_configuration/edit/emails'=>"work_configurations#emails"
  get '/work_configuration/edit/reset_email_default'=>"work_configurations#reset_email_default"
  post '/work_configuration/edit/default_invoice_set'=>"work_configurations#default_invoice_set"
  get '/pdf_settings'=>"work_configurations#pdf_settings"
  get '/client_reminder_settings'=>"work_configurations#client_reminder_settings" 

  #repeat job route
  post '/repeat' => 'jobs#repeat'
  patch '/repeat' => 'jobs#repeat'
  
  post '/buy_a_number'=>'twilios#buy_a_number'
  get '/buy_a_number'=>'twilios#buy_a_number'
  get '/new_message'=>'twilios#new_message'
  post '/today_message_send'=>'twilios#today_message_send'
  post '/message_create'=>'twilios#message_create'
  post '/message_show/:id'=>'twilios#message_show'
  get '/delete_service_number'=>'twilios#delete_service_number', as: :delete_service_number

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end
  get '/communication' => "documents#communication" ,:as=>"communication"

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # All the routes changes through this routes or links first customer action
  
end
