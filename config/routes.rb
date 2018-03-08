Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'pages#home'

  post "/", to: 'wines#search'
  get "/results", to: 'wines#results'
  get "/wine/:id", to: 'wines#show', as: 'show'
end
