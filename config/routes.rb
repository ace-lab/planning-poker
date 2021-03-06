Rails.application.routes.draw do
  root to: 'dashboard#index'

  get 'auth/:provider/callback', to: 'sessions#google_oauth_login'
  get 'auth/failure', to: 'sessions#new'

  get 'favicon.ico', controller: :application, action: :favicon

  controller :sessions do
    get    :login,  action: :new
    post   :login,  action: :create
    delete :logout, action: :destroy
    get    :new_api_key, action: :new_api_key
    post   :new_api_key, action: :set_api_key, as: :set_api_key
  end

  resources :dashboard, only: [:index]

  controller :dashboard do
    get 'project/:id', action: :project, as: :project
    get 'story/:story_id/:vote/:user', action: :vote, as: :vote
    get 'reset/:story_id/:user', action: :reset, as: :reset
    get 'detail/:story_id/:toggle/:user', action: :detail, as: :detail
    get 'reveal/:story_id', action: :reveal, as: :reveal
    post 'select-vote', action: :select, as: :select
    post 'update-story', action: :update, as: :update
    get '/makehangout', action: :get_hangouts_link
    get 'discussion/:story_id', action: :discussion, as: :discussion
  end

  resources :activities, only: [:index] do
    collection do
      get 'meetings'
    end
  end
end