Synthetic::Application.routes.draw do
  
  resources :remote_jobs do as_routes end

  # the app_install heirarchy is not shib protected, so let's do our REST things here
  post 'app_install/remote_jobs' => 'remote_jobs#create'
  post 'app_install/awaiting_remote_processing' => 'remote_jobs#awaiting_remote_processing'
  put  'app_install/starting_remote_processing' => 'remote_jobs#starting_remote_processing'
  put  'app_install/completed_remote_processing' => 'remote_jobs#completed_remote_processing'
  
 
  resources :containers
  match '/containers', :to => 'containers#index', :via => :get, :as =>"containers"
  match '/containers/shiny', :to => 'containers#shiny', :via => :get, :as =>"containers_shiny"  
  match '/containers/renew', :to => 'containers#renew', :via => :get, :as =>"containers_renew"  

  resources :shiny_dockers do as_routes end
  resources :sessions do as_routes end
  resources :admins do as_routes end
  resources :users do as_routes end

  resources :verify_jobs


  get "administration/index"

  get "home/index"
  match 'home/logout'=>'home#logout'
  get 'home/log_the_app_install'

  # convenient way to get a dump of the session and environment
  get 'debug' => 'home#debug'

  root :to => 'home#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
