Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants#find'
      resources :merchants, only: %i[index show] do
        resources :items, only: :index
      end

      get 'items/find_all', to: 'items#find_all'
      resources :items do
        resource :merchant, only: :show
      end

      get 'revenue', to: 'revenue#revenue'
      get 'revenue/items', to: 'revenue#items'
      get 'revenue/unshipped', to: 'revenue#unshipped'
      get 'revenue/weekly', to: 'revenue#weekly'
    end
  end
end
