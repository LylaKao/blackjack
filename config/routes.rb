Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  mount ActionCable.server => '/cable'

  get 'rooms/show'
  root :to => "games#index"

  resources :games, only: [:index]
  post 'start_game' => 'games#start_game'
  post 'end_game' => 'games#end_game'
  post 'restart_game' => 'games#restart_game'

  resources :user_games, only: [:new, :update, :create, :destroy]
end
