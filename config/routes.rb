Rails.application.routes.draw do

  resources :subscribers
  get 'users', to: 'headhunter#users'
  post 'email', to: 'headhunter#email'
  root 'headhunter#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
