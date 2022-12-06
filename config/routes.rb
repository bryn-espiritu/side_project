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
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root "home#index"
    namespace :user do
      resources :invites
      resources :addresses
      resource :user_profile
    end
    resources :home
  end

  namespace :api do
    resources :regions, only: :index, defaults: { format: :json } do
      resources :provinces, only: :index, defaults: { format: :json } do
        resources :city_municipalities, only: :index, defaults: { format: :json } do
          resources :barangays, only: :index, defaults: { format: :json }
        end
      end
    end
  end
end