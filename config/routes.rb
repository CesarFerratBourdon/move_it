Rails.application.routes.draw do

  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}

  root 'homes#index'

  post '/users/:id/createrental' => 'rentals#new_rental'
  get '/users/:id/calculatepricing' => 'rentals#calculate_pricing'


  get '/dashboard' => 'users#show', :as => 'dashboard'
  get '/quote' => 'homes#index'

  get '/rentals.json' => 'rentals#calculate_pricing'  #JSON API request

end
