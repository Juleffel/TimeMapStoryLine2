Rails.application.routes.draw do


  resources :rp_statuses

  # config/routes.rb
  scope "(:locale)", locale: /fr|en/ do
    devise_for :users
    
    get 'xmpp_prebind', to: 'xmpp#prebind'
    get 'xmpp_prebind_test', to: 'xmpp#prebind_test' 
    get 'xmpp_prebind_test_rooms', to: 'xmpp#prebind_test'
    get 'xmpp_prebind_test_contacts', to: 'xmpp#prebind_test_contacts' 
    
    resources :presences
  
    resources :spacetime_positions
  
    resources :links do
      get 'graph', on: :collection
    end
    
    resources :link_natures
  
    resources :characters, only: [:index] do
      get 'map', on: :collection
    end
    post 'characters/:id/destroy_presence' => 'characters#destroy_presence'
    resources :users, only: [] do
      resources :characters, except: [:show]
    end
  
    resources :groups
  
    resources :factions
  
    resources :topics
    
    resources :answers, except: [:index, :show]
    
    resources :categories
  
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".
  
  
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
  # You can have the root of your site routed with "root"
  get '/:locale' => 'home#index'
  root 'home#index'
end
