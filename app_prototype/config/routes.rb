AppPrototype::Application.routes.draw do

  match 'sign_in'  => 'user_sessions#new',     as: :sign_in
  match 'sign_out' => 'user_sessions#destroy', as: :sign_out

  resources :user_sessions, only: [:new, :create, :destroy]

  resources :registrations, only: [:new, :create, :activate]
  match 'sign_up' => 'registrations#new',                      via: :get
  match 'sign_up' => 'registrations#create',                   via: :post
  match 'sign_up/:token/activate' => 'registrations#activate', via: :get

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :users

end
