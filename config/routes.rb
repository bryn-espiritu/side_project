Rails.application.routes.draw do
  # get 'home/new'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      root "users#index"
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users
      end
    end


<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
  # constraints(ClientDomainConstraint.new) do
    resources :home
  # end

<<<<<<< HEAD
>>>>>>> 5e9c05c ([Feature 1] generate model  and added reference from user to home relation included)
=======


>>>>>>> eb6e00e ([Feature 1] added root to home/index)
=======

>>>>>>> 4f9f907 ([Feature 2] adding domain config | adding constraint)
=======
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions' }
    root "home#index"
    resources :home
    resource :user_profile
  end
>>>>>>> b03ebef ([Feature 2] update routes and fix constraint)
end

