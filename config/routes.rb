Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :users
  resources :submissions
  resources :assignments
  resources :enrollments
  resources :courses

  root 'sessions#new'
  get '/about',         to: 'static_pages#about'
  get '/contact',       to: 'static_pages#contact'
  get '/demo',          to: 'static_pages#demo'

  get '/signup',        to: 'users#new'
  post '/signup',       to: 'users#create'
  get '/dashboard',     to: 'users#dashboard'

  get '/login',         to: 'sessions#new'
  post '/login',        to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'

  get '/assignments',   to: 'assignments#index'
  post '/save',         to: 'assignments#save'
  patch '/save',        to: 'assignments#save'
  patch '/autosave',    to: 'assignments#autosave'

  post '/run',          to: 'submissions#run'
  get '/progress/:id',  to: 'assignments#progress'
  get '/submissions',   to: 'submissions#index'

  post '/enroll',       to: 'enrollments#create_enrollment_dashboard'
end
