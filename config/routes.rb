Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["OK"]] }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/services/get-a-divorce', to: 'services#divorce'
  get '/services/end-a-civil-partnership', to: 'services#civilpartnership'
  get '/services/make-child-arrangements', to: 'services#childarrangements'

  get '/get-a-divorce', to: 'services#divorce'
  get '/end-a-civil-partnership', to: 'services#civilpartnership'

  get '/services/:base_path', to: 'services#show'
  get '/services', to: 'services#index'

  get "/browse.json" => redirect("/api/content/browse")

  resources :browse, only: [:show], param: :top_level_slug do
    get ':second_level_slug', on: :member, to: "second_level_browse_page#show"
  end

  get '/prototype', to: 'welcome#index'
  get '/search', to: 'search#results'
  get '/*base_path', to: 'content_items#sticky_nav'
  root to: 'content_items#fall_through'
  post '/:base_path', to: redirect('/%{base_path}/camden')
end
