Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  get "/wines", to:'wines#wines_search'
  post "/", to: 'wines#search'
  get "/likes", to: "wines#likes"
  get "/results", to: 'wines#results'
  get "/wine/:id", to: 'wines#show', as: 'show'
  post "/wine/:id/like", to: 'wines#like', as: 'wine_like'

  # redirect user to search if logged in
  authenticated :user do
    root 'wines#wines_search', as: :authenticated_root
  end

  # root if new user or not logged in
  root to: 'pages#home'

end

