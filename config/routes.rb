Rails.application.routes.draw do
  devise_for :users
  
  resources :bookings, only: [:index, :show, :destroy]
  resources :meeting_participants, only: [:update]
  
  namespace :admin do
    get "users/index"
    get "users/edit"
    get "users/update"
    get 'dashboard', to: 'admin#dashboard'
    resources :users, only: [:index, :edit, :update]
  end
  resources :rooms do
    resources :bookings
  end
  root to: 'rooms#index'
end