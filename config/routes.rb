Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        resources :items, only: :index
      end
      resources :items, only: %i[index show create] do
        resource :merchant, only: :show
      end
    end
  end
end
