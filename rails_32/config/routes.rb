AppPrototype::Application.routes.draw do

  root to: 'pages#root'

  match 'sign_in'  => 'user_sessions#new',     as: :sign_in
  match 'sign_out' => 'user_sessions#destroy', as: :sign_out

  resources :user_sessions, only: [:new, :create, :destroy]

  match 'sign_up' => 'registrations#new',              via: :get,  as: :sign_up
  match 'sign_up' => 'registrations#create',           via: :post, as: :sign_up
  match 'activate/:token' => 'registrations#activate', via: :get,  as: :activation

  match 'forgotten_password' => 'password_resets#new',     via: :get,  as: :forgotten_password
  match 'forgotten_password' => 'password_resets#create',  via: :post, as: :forgotten_password
  match 'reset_password/:token' => 'password_resets#edit', via: :get,  as: :reset_password
  match 'reset_password/:id' => 'password_resets#update',  via: :put

  resources :users

end
