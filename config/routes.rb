Rails.application.routes.draw do
  namespace :hr do
    resources :employees
    resources :leaves do
      collection do
        get :my_leaves
      end
      member do
        patch :approve
        patch :reject
        patch :cancel
      end
    end
  end

  resources :projects do
    resources :reports do
      member do
        patch :submit
        patch :review
      end
    end
    resources :tasks do
      member do
        patch :in_progress
        patch :complete
      end
    end
  end

  resources :tasks, only: [ :index, :new, :create ]
  resources :reports, only: [ :index, :new, :create ]

  namespace :accounting do
    resources :transactions do
      member do
        patch :mark_paid
      end
    end
  end

  devise_for :users
  get "home/index"
  root "home#index"
end
