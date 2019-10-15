Rails.application.routes.draw do
  root to: 'home#index'

  # Authentication Related Routes
  get 'login', to: redirect('/auth/microsoft_v2_auth'), as: 'login'
  get 'logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#auth_failure'

  resources :members, except: :destroy
  resources :events, except: :destroy
  resources :users, only: :index
  resources :meetings, except: :destroy

  get '/calendar_events/generate_pdf',
    to: 'calendar_events#generate_pdf',
    as: 'calendar_events_generate_pdf'

  resources :calendar_events


  post '/users/bulk_update',
    to: 'users#bulk_update'

  # Reports
  get '/reports/attendance/summary',
    to: 'attendance_report#summary',
    as: 'attendance_summary'

  get '/reports/attendance/all_members', 
    to: 'attendance_report#all_members', 
    as: 'attendance_all_members'
  get '/reports/attendance/generate',
    to: 'attendance_report#generate',
    as: 'attendance_generate'
  get '/reports/attendance/:member_id',
    to: 'attendance_report#generate',
    as: 'attendance_report'
  post '/reports/attendance/generate_pdf',
    to: 'attendance_report#generate_pdf',
    as: 'attendance_generate_pdf'

  get '/reports/attendance/generate',
    to: redirect('/reports/attendance/start'),
    as: 'attandance_generate_get'

  get '/reports/attendance/generate_pdf',
    to: redirect('/reports/attendance/start'),
    as: 'attendance_generate_pdf_get'

  #Meetings
  get '/mettings/by_year/:year',
    to: 'meetings#by_year',
    as: 'meetings_by_year'

  #Events
  get '/events/by_date/:date',
    to: 'events#by_date',
    as: 'events_by_date'
end

