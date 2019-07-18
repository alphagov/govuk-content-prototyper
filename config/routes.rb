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

  get '/dfe', to: 'dfe#index'
  get '/government/publications/supporting-early-career-teachers--2/set-high-expectations', to: 'dfe#content_page_1'
  get '/government/publications/supporting-early-career-teachers--2/promote-good-progress', to: 'dfe#content_page_2'
  get '/government/publications/supporting-early-career-teachers--2/plan-and-teach-well-structured-lessons', to: 'dfe#content_page_3'
  get '/government/publications/supporting-early-career-teachers--2/adaptive-teaching', to: 'dfe#content_page_4'
  get '/government/publications/supporting-early-career-teachers--2/manage-behaviour-effectively', to: 'dfe#content_page_5'
  get '/government/publications/supporting-early-career-teachers--2/fulfil-wider-professional-responsibilities', to: 'dfe#content_page_6'
  get '/government/publications/supporting-early-career-teachers--2/demonstrate-good-subject-and-curriculum-knowledge', to: 'dfe#content_page_7'
  get '/government/publications/supporting-early-career-teachers--2/make-accurate-and-productive-use-of-assessment', to: 'dfe#content_page_8'

  get "/browse.json" => redirect("/api/content/browse")

  resources :browse, only: [:show], param: :top_level_slug do
    get ':second_level_slug', on: :member, to: "second_level_browse_page#show"
  end

  get '/prototype', to: 'welcome#index'
  get '/search', to: 'search#results'
  get '/*base_path', to: 'content_items#fall_through'
  root to: 'content_items#fall_through'
  post '/:base_path', to: redirect('/%{base_path}/camden')
end
