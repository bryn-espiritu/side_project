Rails.application.routes.draw do
  namespace :user do
    get 'lotteries/index'
  end
  # get 'home/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      root "users#index"
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users
      resources :items do
        put :start, :pause, :cancel, :end
      end
      resources :categories
      resources :bets do
        put :cancel
      end
      resources :winners do
        put :submit, :pay, :ship, :deliver, :publish, :remove_publish
      end
    end
  end

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root "home#index"
    namespace :user do
      resources :invites
      resources :addresses
      resource :user_profile
      resources :lotteries
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