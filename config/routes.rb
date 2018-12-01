Rails.application.routes.draw do
  root to: 'home#index'

  # Authentication Related Routes
  get 'login', to: redirect('/auth/microsoft_v2_auth'), as: 'login'
  get 'logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#auth_failure'

  # Profile Related 
  get 'me', to: 'me#show', as: 'me'
  get 'me/record_links', to: 'me#get_records', as: 'me_record_links'
  post 'me/update', to: 'me#update_profile', as: 'me_update'

  # Reports
  get '/reports/attendance/start', 
    to: 'attendance_report#select_member', 
    as: 'attendance_start'
  post '/reports/attendance/generate',
    to: 'attendance_report#generate',
    as: 'attendance_generate'
  post '/reports/attendance/generate_pdf',
    to: 'attendance_report#generate_pdf',
    as: 'attendance_generate_pdf'

  get '/reports/attendance/generate',
    to: redirect('/reports/attendance/start'),
    as: 'attandance_generate_get'

  get '/reports/attendance/generate_pdf',
    to: redirect('/reports/attendance/start'),
    as: 'attendance_generate_pdf_get'

  #Events
  get '/events/create_event',
    to: 'events#create_start',
    as: 'events_create_get'

  post '/events/create_event',
    to: 'events#create_do',
    as: 'events_create_post'

  get '/events/edit_event',
    to: 'events#edit_start',
    as: 'events_edit_get'

  post '/events/edit_event/:id',
    to: 'events#edit_by_id',
    as: 'events_edit_by_id'

  get '/events/by_date/:date',
    to: 'events#by_date',
    as: 'events_by_date'

  #Administration
  get '/admin/users',
    to: 'admin#users',
    as: 'admin_users_get'

  post '/admin/users',
    to: 'admin#update_users',
    as: 'admin_users_post'
end
