Rails.application.routes.draw do

  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}

  root 'homes#index'


  # post '/rentals/form' => 'rentals#form'
  post '/users/:id/createrental' => 'rentals#new_rental'
  get 'users/:id/calculatepricing' => 'rental#calculate_pricing'


  get '/users/:id/show' => 'users#show', as: 'dashboard'
  get '/users/:id/quote' => 'users#quote'

end
