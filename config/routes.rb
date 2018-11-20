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

end
