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

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'application#landing'
end
