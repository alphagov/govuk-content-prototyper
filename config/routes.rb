Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["OK"]] }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :welcome, only: :index

  get '/home', to: 'home#index'
  get '/:taxon', to: 'taxons#show', constraints: { taxon: /[a-z].*/ }
  root to: 'welcome#index'
end
