Rails.application.routes.draw do
  namespace :dashboard do
    get "/", to: "home#index", as: :home
  end

  namespace :hr do
    resources :employees do
      resource :personal_detail
    end

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

    resources :salary_batches do
      member do
        patch :mark_paid
      end
      resources :salaries do
        resources :deductions
      end
    end

    resources :salaries do
      member do
        patch :mark_paid
      end
    end

    resources :deductions
  end

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  devise_for :users, skip: [ :registrations ]
end
