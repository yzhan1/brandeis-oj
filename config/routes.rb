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

  get '/login', to: 'static_pages#login'

  get '/assignment_editor', to: 'static_pages#assignment_editor'

  get '/submission_editor', to: 'static_pages#submission_editor'

  get '/assignments_list', to: 'static_pages#assignments_list'

  get '/ta_dashboard', to: 'static_pages#ta_dashboard'

  get '/stdn_dashboard', to: 'static_pages#stdn_dashboard'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'application#landing'
end
