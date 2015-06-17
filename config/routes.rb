Rails.application.routes.draw do
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  as :user do
    # get '/sign_in_as_adler', to: "devise/sessions#new", as: "sign_in"
    # post '/sign_in', to: "devise/sessions#create", as: "user_session"
    # delete '/sign_out', to: "devise/sessions#destroy", as: "destroy_user_session"
    # get '/sign_out', to: "devise/sessions#destroy", as: "sign_out"
    # get '/sign_up', to: "devise/registrations#new", as: "sign_up"
  end
  get '/blog', to: "posts#index", as: "posts"
  get '/blog/:slug', to: "posts#show", as: "post"
  get '/search', to: "posts#search", as: "search_posts"
  get '/author', to: "posts#author", as: "author"
  get '/bing_balance', to: "users#balance", as: "bing_balance"

  resources :posts do
    collection do
      post :render_markdown
    end
    member do
      post :toggle_public
      post :translate
    end
  end

  resources :settings do
    collection do
      post :update_all
      get :edit_all
    end
  end

  resources :users, except: [:index, :show, :create, :update, :new, :edit, :destroy] do
    collection do
      post :subscribe
      get :unsubscribe
      post :send_post_email
      get :info
    end
    member do
    end
    resources :posts, :controller => "users/posts"
    resources :categories, :controller => "users/categories" do
      collection do
        get :edit_all
      end
    end
    resources :screencasts, :controller => "users/screencasts" do
      member do
        post :toggle_public
      end
    end
    resources :trainings, :controller => "users/trainings" do
      member do
        post :toggle_public
        get :selections
        get :not_selected
        post :update_selections
      end
    end
  end
  # get '/users/:name', to: "users#show", as: "user"
  # get '/users/:name/posts', to: "users#posts", as: "edit_posts"
  # get '/users/:name/categories', to: "users#categories", as: "edit_categories"

  get '/categories/:slug', to: "categories#show"
  resources :categories do
    collection do
      post :update_all
    end
  end

  resources :screencasts
  resources :trainings, only: [:index, :show] do
    resources :screencasts
  end

  namespace :store do
    resources :products do
      member do
        post :add_to_cart
      end
    end
    resources :orders do
      member do
        get :place
      end
    end
  end

  root to: "index#index"

end
