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
  resources :calendar_events

  post '/users/bulk_update',
    to: 'users#bulk_update'

  # Reports
  get '/reports/attendance/start', 
    to: 'attendance_report#select_member', 
    as: 'attendance_start'
  get '/reports/attendance/generate',
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

  #Meetings
  get '/meetings/by_range/:start_date/:end_date',
    to: 'meetings#by_date_range',
    as: 'meetings_by_date_range'

  #Events
  get '/events/by_date/:date',
    to: 'events#by_date',
    as: 'events_by_date'

  get '/events/by_range/:start_date/:end_date',
    to: 'events#by_date_range',
    as: 'events_by_date_range'
end

