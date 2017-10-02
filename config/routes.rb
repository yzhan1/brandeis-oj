Rails.application.routes.draw do
  resources :submissions
  resources :assignments
  resources :enrollments
  resources :courses
  resources :students
  resources :teachers

  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/demo', to: 'static_pages#demo'

  get '/student-signup', to: 'students#new'
  post '/student-signup', to: 'students#create'
  get '/stdn-dashboard', to: 'students#dashboard'

  get '/teacher-signup', to: 'teachers#new'
  post '/teacher-signup', to: 'teachers#create'
  get '/ta-dashboard', to: 'teachers#dashboard'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/assignments', to: 'assignments#index'

  get '/assignment-editor', to: 'static_pages#assignment_editor'

  get '/submission-editor', to: 'static_pages#submission_editor'

  get '/assignments-list', to: 'static_pages#assignments_list'
  
end
