Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
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

  root :to => "pages#splash"


  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  post 'games/join', to: 'games#join', as: 'join_game'
  post '/games/:game_id/move', to: "games#move"
  get 'games/:game_id/matching', to: 'games#matching', as: 'match_game'
  get 'games/:game_id/status', to: 'games#status', as: 'game_status'
  get 'games/:game_id/poll', to: 'games#poll', as: 'game_poll'
  get "games/:game_id/win", to: "games#win"
  resources :games


  get "decks/player_one", to: "decks#deck1"
  get "decks/player_two", to: "decks#deck2"
  resources :decks
  post "decks/:id/add_card/:card_id", to: 'decks#add_card', as: "add_card"
  delete "decks/:id/remove_card/:card_id",to:"decks#remove_card", as: "remove_card"

  resources :cards

  get '/profile', to: 'users#profile', as: 'profile'
  resources :users

  get 'pages/home', to: 'pages#home', as: 'home'
  get 'pages/about', to: 'pages#about', as:'about'

end
