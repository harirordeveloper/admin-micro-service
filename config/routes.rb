Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/signup', to: 'users#create'
      post '/signin', to: 'sessions#create'
      delete '/signout', to: 'sessions#destroy'
      resources :companies
      resources :employees
      resources :admin_employees
    end
  end
end
