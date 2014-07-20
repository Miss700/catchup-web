Rails.application.routes.draw do
  resources :boards, only: [:create, :index, :show]
  resources :cards, only: [:create, :update]

  root to: 'users#new'

  resources :users, only: [:create]
end
