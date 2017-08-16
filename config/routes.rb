Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["OK"]] }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/services/:base_path', to: 'services#show'
  get '/services', to: 'services#index'

  get "/browse.json" => redirect("/api/content/browse")

  resources :browse, only: [:show], param: :top_level_slug do
    get ':second_level_slug', on: :member, to: "second_level_browse_page#show"
  end

  get '/prototype', to: 'welcome#index'
  get '/*base_path', to: 'taxons#show', constraints: TaxonConstraint.new
  get '/*base_path', to: 'content_items#show', constraints: ContentItemConstraint.new
  get '/*base_path', to: 'content_items#showforms', constraints: FormConstraint.new
  get '/*base_path', to: 'content_items#fall_through'
  root to: 'content_items#fall_through'
end
