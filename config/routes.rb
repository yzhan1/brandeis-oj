Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :users
  resources :submissions
  resources :assignments
  resources :enrollments
  resources :courses do
    member do
      get 'grades'
      get 'get_csv'
    end
  end

  root 'sessions#new'

  get '/signup',        to: 'users#new'
  post '/signup',       to: 'users#create'
  get '/dashboard',     to: 'users#dashboard'
  post '/announce',     to: 'users#create_announcement'
  post '/enroll',       to: 'enrollments#create_enrollment_dashboard'

  get '/login',         to: 'sessions#new'
  post '/login',        to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'

  post '/save',         to: 'submissions#save_or_run'
  patch '/save',        to: 'submissions#save_or_run'
  patch '/autosave',    to: 'submissions#autosave'
  post '/run',          to: 'submissions#run'
  get '/progress/:id',  to: 'application#progress'

  get '/test',          to: 'assignments#run_tests'
end
