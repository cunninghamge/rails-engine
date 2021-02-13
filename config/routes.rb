Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants#find' 
      resources :merchants, only: %i[index show] do
        resources :items, only: :index
      end
      resources :items do
        resource :merchant, only: :show
      end
    end
  end
end
