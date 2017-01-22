Rails.application.routes.draw do

  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}

  root 'homes#index'


  # post '/rentals/form' => 'rentals#form'
  post '/users/:id/createrental' => 'rentals#create_rental'


  get '/users/:id/show' => 'users#show', as: 'dashboard'

end
