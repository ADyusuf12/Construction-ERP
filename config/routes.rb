Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  namespace :business do
    resources :clients
  end
  namespace :dashboard do
    get "/", to: "home#index", as: :home
  end

  namespace :hr do
    resources :attendance_records do
      collection do
        get :my_attendance
      end
    end
    resources :employees do
      resources :attendance_records, only: [ :index ]
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
    resources :project_expenses
  end

  resources :tasks
  resources :reports
  resources :project_expenses

  namespace :inventory do
    resources :inventory_items do
      resources :stock_movements, only: %i[index new create edit update destroy show]
    end
    resources :warehouses
    resources :stock_movements, only: %i[index show]
    resources :project_inventories, only: [ :create, :edit, :update, :destroy ]
  end

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
