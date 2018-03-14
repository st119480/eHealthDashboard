Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users
  get 'ehealth/index'
  get 'ehealth/aboutus'
  get 'user/profile'
  root :to => 'ehealth#index'
  resources :user
  resources :patient
  resources :doctor


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
