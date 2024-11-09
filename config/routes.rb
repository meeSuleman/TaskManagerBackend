Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  
  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
    end
  end
end