Movierama::Application.routes.draw do

  root to: 'movies#index'

  resources :users, only: [:create, :show] do
    resources :movies, only: [:new, :create] do
      resources :votes, only: [:create, :destroy]      
    end
  end
  resources :sessions, only: [:create]

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
end
