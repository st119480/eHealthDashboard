Rails.application.routes.draw do

  devise_scope :users do
    get "/sign_in" => "devise/sessions#new" # custom path to login/sign_in
    get "/sign_up" => "devise/registrations#new", as: "new_user_registration" # custom path to sign_up/registration
  end

  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  #devise_for :users
  get 'ehealth/index'
  get 'about-us', :to => 'ehealth#aboutus'
  get 'dashboard', :to => 'user#dashboard'

  #see all the users
  get 'all', :to => 'user#index'
  get 'admin', :to => 'admin#index'
  get 'doctor', :to => 'doctor#index'
  get 'patient', :to => 'patient#index'

  # add the users
  get 'new_admin', :to => 'admin#new'
  get 'new_doctor', :to => 'doctor#new'
  get 'new_patient', :to => 'patient#new'
  root :to => 'ehealth#index'
  get 'home', :to => 'ehealth#index'
  resources :user
  resources :patient do
    resources :appointment
    resources :test
  end

  resources :doctor
  resources :admin


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end

