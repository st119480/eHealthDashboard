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

  root :to => 'ehealth#index'
  get 'home', :to => 'ehealth#index'
  resources :user do
    get 'chart_patient'
  end
  resources :patient do
    resources :appointment
    resources :test
  end

  resources :doctor
  resources :nurse
  resources :admin

  namespace :charts do
    get 'all_tests'
    get 'chart'
  end



  #api
  # namespace :api do
  #   namespace :v1 do
  #       resources :test, only: [:create, :index, :show]
  #   end
  # end


end

