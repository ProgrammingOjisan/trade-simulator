Rails.application.routes.draw do
    root to: "conditions#new"
    get 'ranking', to: "conditions#ranking"
    get 'simulation', to: "conditions#new"
    post 'simulation', to: "conditions#create"
    patch 'simulation', to: "conditions#create"
    get 'signup', to: "users#new"
    get 'login', to: "sessions#new"
    post 'login', to: "sessions#create"
    delete 'logout', to: 'sessions#destroy'
    resources :users, only: [:index, :show, :new, :create]
    resources :conditions, only: [:index, :show]
    resources :favorites, only: [:create, :destroy]
end
