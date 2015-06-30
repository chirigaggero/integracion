Rails.application.routes.draw do

  get 'dashboards/ventas'

  get 'dashboards/nivel_servicio'

  get 'dashboards/contable'

  get 'dashboards/bodega'

  get 'dashboards/productos'

  get 'dashboards/fabrica'

  get 'dashboards/ofertas'

  get 'dashboards/grupos'

  get '/ecommerce' => 'ecommerce#products'

  get 'ecommerce/shoppingcart/:product/:quantity' => 'ecommerce#products'

  get 'ecommerce/shoppingcart/:destroy' => 'ecommerce#shoppingcart'

  get 'ecommerce/products'

  get 'ecommerce/shoppingcart'

  get 'ecommerce/checkout'

  get 'ecommerce/ok'
  
  get 'ecommerce/fail'

  get 'orden_compra/estado'

  get 'internacional/ftp'

  get 'home/index'

  get 'b2b/documentation'

  put 'b2b/new_user'

  post 'b2b/get_token'

  post 'b2b/new_order'

  post 'b2b/order_accepted'

  post 'b2b/order_canceled'

  post 'b2b/order_rejected'

  post 'b2b/invoice_paid'

  post 'b2b/invoice_rejected'

  get 'b2b/bank_account'

  post 'b2b/prueba'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'home#index'

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
