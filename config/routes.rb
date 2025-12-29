Rails.application.routes.draw do
  namespace :hr do
    resources :employees
    # later we can add more HR resources here, e.g.:
    # resources :leaves
    # resources :appraisals
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

  resources :transactions do
    member do
      patch :mark_paid
    end
  end

  devise_for :users
  get "home/index"
  root "home#index"
end
