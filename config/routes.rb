Rails.application.routes.draw do

  get 'sessions/new'

  get '/'                             => 'employees#home'
  get 'feedback'                      => 'admin#feedback'
  post 'feedback_deliver'             => 'admin#feedback_deliver'

  get 'employees'                     => 'employees#index'
  get 'employees/team'                => 'employees#team'
  get 'employees/import'              => 'employees#import'
  get 'employees/:id'                 => 'employees#show', as: :employee
  get 'employees/:id/achievements'    => 'employees#achievements'

  get 'bucks'                         => 'bucks#index'
  get 'bucks/new'                     => 'bucks#new'
  get 'bucks/import'                  => 'bucks#import'
  post 'bucks'                        => 'bucks#create'
  get 'bucks/issued'                  => 'bucks#issued'
  get 'bucks/pending'                 => 'bucks#pending'
  get 'bucks/pending/:id'             => 'bucks#approve'
  post 'bucks/pending/:id'            => 'bucks#update'
  get 'bucks/:id'                     => 'bucks#show', as: :buck
  post 'bucks/new'                    => 'bucks#search'
  get 'bucks/delete/:id'              => 'bucks#delete'

  get 'purchase/start'                => 'purchases#start'
  get 'purchase/finish/:id'           => 'purchases#finish'
  post 'purchase/finish/:id'          => 'purchases#complete'
  get 'purchase/reserved'             => 'purchases#reserved'
  get 'exchange'                      => 'purchases#exchange'

  get 'prizes'                        => 'prizes#index'
  get 'prizes/orders'                 => 'purchases#orders_personal'
  get 'prizes/manage'                 => 'prizes#manage'
  get 'prizes/new'                    => 'prizes#new'
  post 'prizes'                       => 'prizes#create'
  get 'prizes/edit/:id'               => 'prizes#edit'
  get 'prizes/:id'                    => 'prizes#show'
  post 'prizes/:id'                   => 'purchases#complete'
  post 'prizes/edit/:id'              => 'prizes#update'
  get 'prizes/discontinue/:id'        => 'prizes#discontinue'
  get 'prizes/:id/stock'              => 'prizes#stock'

  get 'prizes/manage/:id'             => 'prize_subcats#manage'
  post 'prizes/manage/:id'            => 'prize_subcats#create'
  get 'prizes/manage/:id/new'         => 'prize_subcats#new'
  get 'prizes/manage/type/:id'        => 'prize_subcats#edit'
  post 'prizes/manage/type/:id'       => 'prize_subcats#update'

  get 'jobs'                          => 'jobs#index'
  get 'jobs/import'                   => 'jobs#import'

  get 'login'                         => 'sessions#new'
  post 'login'                        => 'sessions#create'
  delete 'logout'                     => 'sessions#destroy'

  put 'admin/dept_budgets'            => 'departments#update'
  get 'admin/dept_budgets'            => 'departments#edit'
  post 'admin/dept_budgets'           => 'departments#update'
  get 'admin/logs/bucks'              => 'bucks#logs'
  get 'admin/logs/store'              => 'prizes#logs'
  get 'admin/bucks/analyze'           => 'bucks#analyze'
  get 'admin/orders'                  => 'purchases#orders'
  get 'admin/orders/pickup/:id'       => 'purchases#pickup'
  get 'admin/orders/drop/:id'         => 'purchases#drop'
  get 'admin/orders/confirm/:id'      => 'purchases#confirm'
  get 'admin/hard_reset'              => 'override#verify'
  get 'admin/hard_reset/:key'         => 'override#process'

  get 'roles'                         => 'roles#index'
  get 'roles/new'                     => 'roles#new'
  get 'roles/edit/:id'                => 'roles#edit'
  get 'roles/assign/:id'              => 'roles#assign'
  post 'roles/edit/:id'               => 'roles#update'
  post 'roles'                        => 'roles#create'
  get 'roles/assign/:id/add'          => 'roles#add_to_role'
  get 'roles/assign/:id/remove'       => 'roles#remove_from_role'
  get 'roles/delete/:id'              => 'roles#delete'

  get 'favorites'                     => 'favorites#index'
  get 'favorites/create/'             => 'favorites#create'

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
