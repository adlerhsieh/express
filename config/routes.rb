Rails.application.routes.draw do
  devise_for :users, :skip => [:sessions]
  as :user do
    get '/sign_in_as_adler', to: "devise/sessions#new", as: "sign_in"
    post '/sign_in', to: "devise/sessions#create", as: "user_session"
    delete '/sign_out', to: "devise/sessions#destroy", as: "destroy_user_session"
    get '/sign_out', to: "devise/sessions#destroy", as: "sign_out"
    get '/sign_up', to: "devise/registrations#new", as: "sign_up"
  end
  get '/blog', to: "posts#index", as: "posts"
  get '/blog/:slug', to: "posts#show", as: "post"
  get '/search', to: "posts#search", as: "search_posts"
  get '/author', to: "posts#author", as: "author"
  resources :posts do
    collection do
      post :render_markdown
    end
    member do
      post :toggle_public
    end
  end

  resources :settings do
    collection do
      post :update_all
      get :edit_all
    end
  end

  resources :users do
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

  root to: "index#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
