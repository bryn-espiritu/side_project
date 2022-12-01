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

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions' }
    root "home#index"
    resources :home
    resource :user_profile
  end
end

