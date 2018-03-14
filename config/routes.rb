Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'pages#home'

  post "/", to: 'wines#search'
  get "/likes", to: "wines#likes"
  get "/results", to: 'wines#results'
  get "/wine/:id", to: 'wines#show', as: 'show'
  post "/wine/:id/like", to: 'wines#like', as: 'wine_like'
end
