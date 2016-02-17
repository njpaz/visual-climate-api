Rails.application.routes.draw do
  namespace :api do
    resources :data_sets, only: [:index, :show]
    resources :data_types, only: [:index, :show]
    resources :data_categories, only: [:index, :show]
    resources :locations, only: [:index, :show]
    resources :location_categories, only: [:index, :show]
    resources :stations, only: [:index, :show]
    resources :weather_data, only: [:index, :show]
  end
end
