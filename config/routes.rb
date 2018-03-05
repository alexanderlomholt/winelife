Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  post "/", to: 'wines#search'
  get "/results", to: 'wines#results'
  get "/wine/:id", to: 'wines#show'
end
