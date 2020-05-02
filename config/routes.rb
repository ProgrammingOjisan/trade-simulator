Rails.application.routes.draw do
  get 'favorites/create'
  get 'favorites/destroy'
    root to: "conditions#new"
    
    get 'signup', to: "users#new"
    get 'login', to: "sessions#new"
    post 'login', to: "sessions#create"
    delete 'logout', to: 'sessions#destroy'
    resources :users, only: [:index, :show, :new, :create]
    resources :conditions, only: [:index, :show, :new, :create, :update]
    resources :favorites, only: [:create, :destroy]
end
