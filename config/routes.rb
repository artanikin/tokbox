Rails.application.routes.draw do
  devise_for :users
  root "rooms#index"

  resources :rooms, except: :destroy do
    resources :session_users, only: [:new, :create, :edit, :update], shallow: true
  end
end
