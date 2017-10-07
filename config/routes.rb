Rails.application.routes.draw do
  resources :users
  resources :submissions
  resources :assignments
  resources :enrollments
  resources :courses

  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/demo', to: 'static_pages#demo'

  get '/user-signup', to: 'users#new'
  post '/user-signup', to: 'users#create'
  get '/dashboard', to: 'user#dashboard'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/assignments', to: 'assignments#index'

  get '/assignment-editor', to: 'static_pages#assignment_editor'

  get '/submission-editor', to: 'static_pages#submission_editor'

  get '/assignments-list', to: 'static_pages#assignments_list'
  
end
