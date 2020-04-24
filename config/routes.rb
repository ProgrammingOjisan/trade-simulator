Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    root to: "conditions#new"
    
    get 'signup', to: "users#new"
    get 'login', to: "sessions#new"
    post 'login', to: "sessions#create"
    delete 'logout', to: 'sessions#destroy'
    resources :users, only: [:index, :show, :new, :create]
    resources :conditions, only: [:index, :new, :create, :edit, :update, :destroy]
end