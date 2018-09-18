Rails.application.routes.draw do
  resources :shorteners
  get "/:shorten_url", to: "shorteners#original_redirect"
  get "shortners/original_url", to: "shorteners#fetch_original_url"
  root to: 'shorteners#index'

  resources :shorteners do
          collection { post :import }
        end

end
