Rails.application.routes.draw do
    root to: "conditions#new"
    
    get 'signup', to: "users#new"
    get 'login', to: "sessions#new"
    post 'login', to: "sessions#create"
    delete 'logout', to: 'sessions#destroy'
    resources :users, only: [:index, :show, :new, :create] do
        member do
            get :favorites
        end
    end

    resources :conditions, only: [:index, :show, :new, :create, :update]
    resources :favorites, only: [:create, :destroy]
end
