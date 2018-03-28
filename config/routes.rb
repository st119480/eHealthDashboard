Rails.application.routes.draw do

  devise_for :users
  get 'ehealth/index'
  get 'ehealth/aboutus'
  get 'user/profile'
  root :to => 'ehealth#index'
  resources :user
  resources :patient do
    resources :appointment
    resources :test
  end

  resources :doctor
  resources :admin


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
