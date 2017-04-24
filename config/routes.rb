Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["OK"]] }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :welcome, only: :index

  get '/home', to: 'home#index'
  get '/:theme(/*taxon)', to: 'taxons#show', constraints: TaxonConstraint.new
  get '/*base_path', to: 'content_items#show'
  root to: 'welcome#index'
end
