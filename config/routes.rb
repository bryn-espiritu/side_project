Rails.application.routes.draw do
  # get 'home/index'
  # get 'home/new'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  namespace :admin do
    resources :users
  end

<<<<<<< HEAD
=======
  # constraints(ClientDomainConstraint.new) do
    resources :home
  # end

>>>>>>> 5e9c05c ([Feature 1] generate model  and added reference from user to home relation included)
end
