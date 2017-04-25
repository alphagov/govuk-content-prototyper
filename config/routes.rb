Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["OK"]] }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/prototype', to: 'welcome#index'
  get '/*base_path', to: 'taxons#show', constraints: TaxonConstraint.new
  get '/*base_path', to: 'content_items#show', constraints: ContentItemConstraint.new
  get '/*base_path', to: 'content_items#fall_through'
  root to: 'content_items#fall_through'
end
